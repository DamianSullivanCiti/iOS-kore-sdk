//
//  SDKConfiguration.swift
//  KoreBotSDKDemo
//
//  Created by developer@kore.com on 12/16/16.
//  Copyright © 2016 Kore Inc. All rights reserved.
//

import UIKit
import KoreBotSDK

class SDKConfiguration: NSObject {
    
    struct dataStoreConfig {
        static let resetDataStoreOnConnect = true // This should be either true or false. Conversation with the bot will be persisted, if it is false.
    }
    
    struct botConfig {
//        static let clientId = "cs-8abb3101-032f-5b8f-8150-91943f695735" // Copy this value from Bot Builder SDK Settings ex. cs-5250bdc9-6bfe-5ece-92c9-ab54aa2d4285
//
//        static let clientSecret = "" // Copy this value from Bot Builder SDK Settings ex. Wibn3ULagYyq0J10LCndswYycHGLuIWbwHvTRSfLwhs=
//
//        static let botId =  "st-c6dc9e67-91aa-5d08-b14b-cdd6f3910494" // Copy this value from Bot Builder -> Channels -> Web/Mobile Client  ex. st-acecd91f-b009-5f3f-9c15-7249186d827d
//
//        static let chatBotName = "TestBot" // Copy this value from Bot Builder -> Channels -> Web/Mobile Client  ex. "Demo Bot"
//
//        static let identity = "damian.sullivan@citi.com"// This should represent the subject for JWT token. This can be an email or phone number, in case of known user, and in case of anonymous user, this can be a randomly generated unique id.
//

        static let clientId = "cs-8c1c4ee9-25ac-5569-8781-1c7c73973442"
        static let clientSecret = "9d+Yh75oln5YDtNzhtfhP/OD+HwCtKvTxjIU1bgYX0k="
        static let botId =  "st-74a6c216-2d56-552a-9652-840ad4a53183"
        static let chatBotName = "LuCi"
        static let identity = "pallavi.joshi@citi.com"
        static let isAnonymous = true
    }
    
    struct serverConfig {
//        static let JWT_SERVER = String(format: "https://citisso-7dc8.nam.nsroot.net/jwtservice/api/") // Replace it with the actual JWT server URL, if required. Refer to developer documentation for instructions on hosting JWT Server.
//
//        static func koreJwtUrl() -> String {
//            return String(format: "%@users/sts", JWT_SERVER)
//        }
//
//        static let BOT_SERVER = String(format: "https://citisso-7dc8.nam.nsroot.net/")

        static let JWT_SERVER = String(format: "https://citisso-7dc8.nam.nsroot.net/jwt/api/v1/")
        static func koreJwtUrl() -> String {
            return String(format: "%@users/sts", JWT_SERVER)
        }
        static let BOT_SERVER = String(format: "https://citisso-7dc8.nam.nsroot.net/")
    }
    
    // googleapi speech API_KEY
    struct speechConfig {
        static let API_KEY = "<speech_api_key>"
    }
}
