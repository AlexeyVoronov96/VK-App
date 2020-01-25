//
//  APIRoute.swift
//  VK App
//
//  Created by Алексей Воронов on 25.01.2020.
//  Copyright © 2020 Алексей Воронов. All rights reserved.
//

import Foundation

protocol APIRoute {
    var host: String { get }
    
    var path: String { get }
    
    var params: [String: String] { get }
}
