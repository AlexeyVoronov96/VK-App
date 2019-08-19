//
//  FeedCellViewModels.swift
//  VK App
//
//  Created by Алексей Воронов on 18.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import Kingfisher
import UIKit

protocol FeedCellViewModel {
    var iconURLString: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var photoAttachement: FeedCellPhotoAttachementViewModel? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    
    var sizes: FeedCellSizes { get }
}

protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var attachementFrame: CGRect { get }
    var bottomViewFrame: CGRect { get }
    
    var totalHeight: CGFloat { get }
}

protocol FeedCellPhotoAttachementViewModel {
    var photoURLString: String { get }
    var width: Int { get }
    var height: Int { get }
}
