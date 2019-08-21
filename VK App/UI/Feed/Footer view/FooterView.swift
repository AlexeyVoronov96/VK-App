//
//  FooterView.swift
//  VK App
//
//  Created by Алексей Воронов on 21.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import UIKit

class FooterView: UIView {
    private var postsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = #colorLiteral(red: 0.3725763559, green: 0.679697752, blue: 0.9031428695, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.color = #colorLiteral(red: 0.3725763559, green: 0.679697752, blue: 0.9031428695, alpha: 1)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postsCountLabel)
        addSubview(loader)
        
        postsCountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        postsCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        postsCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        postsCountLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        loader.topAnchor.constraint(equalTo: postsCountLabel.bottomAnchor, constant: 4).isActive = true
        loader.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func showLoader() {
        loader.startAnimating()
    }
    
    func set(title: String?) {
        postsCountLabel.text = title
        loader.stopAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
