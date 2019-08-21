//
//  Requests.swift
//  VK App
//
//  Created by Алексей Воронов on 18.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import Foundation
import VK_ios_sdk

enum Requests {
    case getFeed(nextFrom: String?)
    case getUser
    
    var host: String {
        return "api.vk.com"
    }
    
    var path: String {
        switch self {
        case .getFeed:
            return "/method/newsfeed.get"
            
        case .getUser:
            return "/method/users.get"
        }
    }
    
    var params: [String: String] {
        switch self {
        case let .getFeed(nextFrom):
            var params = [
                "filters": "post,photo",
                "access_token": VKSdk.accessToken()?.accessToken ?? "",
                "v": "5.101"
            ]
            
            if let nextFrom = nextFrom {
                params["start_from"] = nextFrom
            }
            
            return params
            
        case .getUser:
            return [
                "fields": "photo_100",
                "access_token": VKSdk.accessToken()?.accessToken ?? "",
                "user_ids": VKSdk.accessToken()?.userId ?? "",
                "v": "5.101"
            ]
        }
    }
}
