//
//  FeedModels.swift
//  VK App
//
//  Created by Алексей Воронов on 18.08.2019.
//  Copyright (c) 2019 Алексей Воронов. All rights reserved.
//

import UIKit

enum Feed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getNewsFeed
        case revealPostIds(postId: Int)
      }
    }
    struct Response {
      enum ResponseType {
        case present(feed: FeedResponse, revealedPostIds: [Int])
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case display(feed: FeedViewModel)
      }
    }
  }
}

struct FeedViewModel {
    let cells: [Cell]
    
    struct Cell: FeedCellViewModel {
        var postId: Int
        var iconURLString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var photoAttachement: FeedCellPhotoAttachementViewModel?
        
        var sizes: FeedCellSizes
    }
    
    struct FeedCellPhotoAttachement: FeedCellPhotoAttachementViewModel {
        var photoURLString: String
        var height: Int
        var width: Int
    }
}