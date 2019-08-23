//
//  TitleView.swift
//  VK App
//
//  Created by Алексей Воронов on 21.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import Kingfisher
import UIKit

protocol TitleViewDelegate: class {
    func logout()
}

protocol TitleViewViewModel {
    var photoUrl: String? { get }
}

class TitleView: UIView {
    weak var delegate: TitleViewDelegate!
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    private var userAvatarButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        overlayView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userAvatarButton.layer.masksToBounds = true
        userAvatarButton.layer.cornerRadius = userAvatarButton.frame.width / 2
    }
    
    func set(userViewModel: TitleViewViewModel) {
        userAvatarButton.imageView?.kf.indicatorType = .activity
        userAvatarButton.kf.setImage(with: URL(string: userViewModel.photoUrl ?? ""), for: .normal)
    }
    
    private func overlayView() {
        addSubview(userAvatarButton)
        
        userAvatarButton.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        userAvatarButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        userAvatarButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        userAvatarButton.widthAnchor.constraint(equalTo: userAvatarButton.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func logout(_ sender: UIButton) {
        delegate.logout()
    }
}
