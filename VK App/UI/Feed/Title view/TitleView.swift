//
//  TitleView.swift
//  VK App
//
//  Created by Алексей Воронов on 21.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import Kingfisher
import UIKit

protocol TitleViewViewModel {
    var photoUrl: String? { get }
}

class TitleView: UIView {
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    private var userAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        overlayView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userAvatarImageView.layer.masksToBounds = true
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width / 2
    }
    
    func set(userViewModel: TitleViewViewModel) {
        userAvatarImageView.kf.indicatorType = .activity
        userAvatarImageView.kf.setImage(with: URL(string: userViewModel.photoUrl ?? ""))
    }
    
    private func overlayView() {
        addSubview(userAvatarImageView)
        
        userAvatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        userAvatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        userAvatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        userAvatarImageView.widthAnchor.constraint(equalTo: userAvatarImageView.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
