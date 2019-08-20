//
//  GalleryCollectionViewCell.swift
//  VK App
//
//  Created by Алексей Воронов on 20.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    static let reuseId: String = "GalleryCollectionViewCell"
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImageView)
        
        postImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        postImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        postImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        postImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        postImageView.image = nil
    }
    
    func set(imageURLString: String) {
        postImageView.kf.indicatorType = .activity
        postImageView.kf.setImage(with: URL(string: imageURLString))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
