//
//  NetworkServiceErrors.swift
//  VK App
//
//  Created by Алексей Воронов on 25.01.2020.
//  Copyright © 2020 Алексей Воронов. All rights reserved.
//

import Foundation

enum NetworkServiceErrors: LocalizedError {
    case internalInconsistency
    case requestError
    case unknownError
    case dataNil
}
