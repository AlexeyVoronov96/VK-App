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
    case getFeed
    
    var host: String {
        return "api.vk.com"
    }
    
    var path: String {
        switch self {
        case .getFeed:
            return "/method/newsfeed.get"
        }
    }
    
    var params: [String: String] {
        switch self {
        case .getFeed:
            return [
                "filters": "post,photo",
                "access_token": VKSdk.accessToken()?.accessToken ?? "",
                "v": "5.101"
            ]
        }
    }
}
