//
//  User.swift
//  VK App
//
//  Created by Алексей Воронов on 21.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import Foundation

struct UserResponseWrapped: Decodable {
    let response: UserResponses
}

typealias UserResponses = [UserResponse]
struct UserResponse: Decodable {
    let photo100: String?
}
