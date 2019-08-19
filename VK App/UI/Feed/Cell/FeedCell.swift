//
//  FeedCell.swift
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
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
}

protocol FeedCellPhotoAttachementViewModel {
    var photoURLString: String { get }
    var width: Int { get }
    var height: Int { get }
}

class FeedCell: UITableViewCell {
    static let reuseIdentifier: String = "FeedCell"
    
    @IBOutlet private var resourceIconImageView: UIImageView!
    @IBOutlet private var resourceNameLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    
    @IBOutlet private var postTextLabel: UILabel!
    
    @IBOutlet private var likesLabel: UILabel!
    @IBOutlet private var commentsLabel: UILabel!
    @IBOutlet private var sharesLabel: UILabel!
    @IBOutlet private var viewsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(_ viewModel: FeedCellViewModel) {
        resourceIconImageView.kf.setImage(with: URL(string: viewModel.iconURLString))
        
        resourceNameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postTextLabel.text = viewModel.text
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        sharesLabel.text = viewModel.shares
        viewsLabel.text = viewModel.views
    }
}
