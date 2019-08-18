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

struct CountableItem: Decodable {
    let count: Int
}
