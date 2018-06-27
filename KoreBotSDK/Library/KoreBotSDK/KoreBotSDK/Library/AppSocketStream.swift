//
//  AppSocketStream.swift
//

import Foundation
import Starscream
import GD.SecureCommunication

enum GDSocketState {
    case closed
    case bound
}

// Need a max read buffer size, needs to be reasonably large
let kSocketBufferMax = 32768

let kAppSocketStreamErrorAlreadyBound = -1
let kAppSocketStreamErrorNoHostAddress = -2


class AppSocketStream : NSObject, WSStream, GDSocketDelegate {

    // The Starscream Websocket delegate, this is set by WebSocket
    weak var delegate: WSStreamDelegate?

    // GDSocket instance
    private var gdSocket: GDSocket? = nil
    // Current state of the socket
    private var gdSocketState = GDSocketState.closed
    // Any error propogated by the socket
    private var gdSocketError = GDSocketErrorType.none

    // Need to queue up anything written before the socket is open
    private var writeQueue = [Data]()
    // Mutex lock for write queue, since it's accessed by multiple background threads
    private var writeQueueLock = NSLock()

    // MARK: Write queue

    private func pushWriteQueue(data: Data) {
        self.writeQueueLock.lock()
        self.writeQueue.append(data)
        self.writeQueueLock.unlock()
    }

    private func popWriteQueue() -> Data? {
        self.writeQueueLock.lock()
        var data: Data? = nil
        if self.writeQueue.count > 0 {
            data = self.writeQueue.removeFirst()
        }
        self.writeQueueLock.unlock()
        return data
    }


    // MARK: WSStream methods

    func connect(url: URL, port: Int, timeout: TimeInterval, ssl: SSLSettings, completion: @escaping ((Error?) -> Void)) {

        guard self.gdSocketState == .closed else {
            NSLog("WEBSOCKET: connect: socket already bound, aborting")
            completion(NSError(domain: "AppSocketStream", code: kAppSocketStreamErrorAlreadyBound, userInfo: nil))
            return
        }

        guard let host = url.host else {
            NSLog("WEBSOCKET: connect: host is nil, aborting")
            completion(NSError(domain: "AppSocketStream", code: kAppSocketStreamErrorNoHostAddress, userInfo: nil))
            return
        }
        let port32 = Int32(port)

        NSLog("WEBSOCKET: connect: host: \(host), port: \(port32), useSSL: \(ssl.useSSL)")
        self.gdSocket = GDSocket(host, onPort: port32, andUseSSL: ssl.useSSL)
        self.gdSocket?.delegate = self

        if ssl.useSSL == false {
            self.gdSocket?.disableHostVerification()
        }
        if ssl.disableCertValidation {
            self.gdSocket?.disablePeerVerification()
        }
        self.gdSocket?.connect()
        completion(nil)
    }

    func write(data: Data) -> Int {
        return self.performWrite(data: data, flush: true, allowQueue: true)
    }

    private func performWrite(data: Data, flush: Bool, allowQueue: Bool) -> Int {
        guard let socket = self.gdSocket else {
            NSLog("WEBSOCKET: Stream write: GDSocket was nil, aborting")
            return -1
        }

        guard let writeStream = socket.writeStream else {
            NSLog("WEBSOCKET: Stream write: GDSocket writeStream was nil, aborting")
            return -1
        }

        guard self.gdSocketState == .bound else {
            if allowQueue {
                NSLog("WEBSOCKET: Stream write: GDSocket not connected yet, queuing and deferring")
                self.pushWriteQueue(data: data)
                return data.count
            } else {
                NSLog("WEBSOCKET: Stream write: GDSocket not connected, skipping")
                return 0
            }
        }

        writeStream.write(data)
        if flush {
            socket.write()  // flush
        }
        return data.count
    }

    // Flushes any data writes pending on the socket
    private func flush() {
        guard let socket = self.gdSocket else {
            NSLog("WEBSOCKET: Stream flush: GDSocket was nil")
            return
        }
        socket.write()  // flush
    }

    func read() -> Data? {
        guard let socket = self.gdSocket else {
            NSLog("WEBSOCKET: Stream read: GDSocket was nil")
            return nil
        }

        guard let readStream = socket.readStream else {
            NSLog("WEBSOCKET: Stream read: GDSocket readStream was nil")
            return nil
        }

        let available = readStream.bytesUnread()
        guard available > 0 && available < kSocketBufferMax else {
            NSLog("WEBSOCKET: Stream read: Unexpected value for readStream.bytesUnread: \(available)")
            return nil
        }

        let buf = UnsafeMutablePointer<Int8>.allocate(capacity: Int(available))
        let length = readStream.read(buf, toMaxLength: available)
        if length < 1 {
            NSLog("WEBSOCKET: Stream read: Unexpected length from read: \(length)")
            return nil
        }
        return Data(bytes: buf, count: Int(length))
    }

    func cleanup() {
        if let socket = self.gdSocket {
            NSLog("WEBSOCKET: Stream cleanup: disconnecting GDSocket")
            socket.disconnect()
        }
    }


    // MARK: GDSocketDelegate methods

    func onOpen(_ socket: Any) {
        self.gdSocketState = .bound
        while let data = self.popWriteQueue() {
            NSLog("WEBSOCKET: Stream (GDSocket) onOpen, writing queued data: \(data.count) bytes")
            _ = self.performWrite(data: data, flush: false, allowQueue: false)
        }
        self.flush()
    }

    func onRead(_ socket: Any) {
        self.delegate?.newBytesInStream()
    }

    func onClose(_ socket: Any) {
        NSLog("WEBSOCKET: Stream (GDSocket) onClose")
        self.gdSocketState = .closed
        self.gdSocket?.delegate = nil
        self.gdSocket = nil
    }

    func onErr(_ error: Int32, inSocket socket: Any) {
        let errorInt = Int(error)
        if let errorType = GDSocketErrorType(rawValue: errorInt) {
            self.gdSocketError = errorType
        }
        NSLog("WEBSOCKET: Stream (GDSocket) onErr: error code \(error)")
        self.delegate?.streamDidError(error: NSError(domain: "GD Websocket", code: errorInt, userInfo: nil))
    }

    func sslTrust() -> (trust: SecTrust?, domain: String?) {
        return (nil, nil)
    }


}


