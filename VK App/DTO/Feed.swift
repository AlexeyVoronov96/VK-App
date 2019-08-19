//
//  Feed.swift
//  VK App
//
//  Created by Алексей Воронов on 18.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import Foundation

struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}

struct FeedResponse: Decodable {
    let items: FeedItems
    let profiles: Profiles
    let groups: Groups
}

typealias FeedItems = [FeedItem]
struct FeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let attachments: Attachments?
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
}

protocol ProfileRepresantable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

typealias Profiles = [Profile]
struct Profile: Decodable, ProfileRepresantable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    var name: String {
        return firstName + lastName
    }
    
    var photo: String {
        return photo100
    }
}

typealias Groups = [Group]
struct Group: Decodable, ProfileRepresantable {
    let id: Int
    let name: String
    let photo100: String
    
    var photo: String {
        return photo100
    }
}

typealias Attachments = [Attachement]
struct Attachement: Decodable {
    let photo: Photo?
}

struct Photo: Decodable {
    let sizes: PhotoSizes
    
    var url: String {
        return getNecessarySize().url
    }
    
    var height: Int {
        return getNecessarySize().height
    }
    
    var width: Int {
        return getNecessarySize().width
    }
    
    private func getNecessarySize() -> PhotoSize {
        if let necessarySize = sizes.first(where: { $0.type == .x }) {
            return necessarySize
        } else if let largestSize = sizes.last {
            return largestSize
        } else {
            return PhotoSize(type: .z, url: "wrong image url", width: 0, height: 0)
        }
    }
}

typealias PhotoSizes = [PhotoSize]
struct PhotoSize: Decodable {
    let type: SizeType
    let url: String
    let width: Int
    let height: Int
}

enum SizeType: String, Decodable {
    case s
    case m
    case x
    case o
    case p
    case q
    case r
    case y
    case z
    case w
}

struct CountableItem: Decodable {
    let count: Int
}
