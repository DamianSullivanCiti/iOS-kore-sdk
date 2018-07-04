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
        static let clientId = "cs-8c1c4ee9-25ac-5569-8781-1c7c73973442"
        static let clientSecret = "9d+Yh75oln5YDtNzhtfhP/OD+HwCtKvTxjIU1bgYX0k="
        static let botId =  "st-74a6c216-2d56-552a-9652-840ad4a53183"
        static let chatBotName = "LuCi"
        static let identity = "pallavi.joshi@citi.com"
        static let isAnonymous = true
    }
    
    struct serverConfig {

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
