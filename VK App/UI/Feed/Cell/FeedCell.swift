//
//  FeedCell.swift
//  VK App
//
//  Created by Алексей Воронов on 19.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import Kingfisher
import UIKit

protocol FeedCellDelegate: class {
    func revealPost(for cell: FeedCell)
}

final class FeedCell: UITableViewCell {
    static let reuseId = "FeedCell"
    
    weak var delegate: FeedCellDelegate?
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Top view elements
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let resourceIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let resourceNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Post content elements
    private let postTextView: UITextView = {
        let textView = UITextView()
        textView.font = Constants.postLabelFont
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        let padding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        textView.dataDetectorTypes = .all
        return textView
    }()
    
    private let moreTextButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(#colorLiteral(red: 0.4, green: 0.6235294118, blue: 0.831372549, alpha: 1), for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.setTitle("Показать полностью...", for: .normal)
        return button
    }()
    
    private let galleryCollectionView = GalleryCollectionView()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // MARK: - Bottom view elements
    private let bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let likesView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let commentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sharesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let likesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "like")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let commentsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "comment")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let sharesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "share")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let viewsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "eye")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    private let commentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    private let sharesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    override func prepareForReuse() {
        resourceIconImageView.image = nil
        postImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowOpacity = 0.15
        cardView.layer.shadowRadius = 5
        cardView.layer.shouldRasterize = true
        cardView.layer.cornerRadius = 10
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        resourceIconImageView.layer.cornerRadius = Constants.topViewHeight / 2
        resourceIconImageView.clipsToBounds = true
        
        moreTextButton.addTarget(self, action: #selector(moreTextButtonAction), for: .touchUpInside)
        
        overlayFirstLayer()
        overlayCardView()
        
        overlayTopView()
        overlayBottomView()
        overlayCountViews()
    }
    
    @objc private func moreTextButtonAction(_ sender: UIButton) {
        delegate?.revealPost(for: self)
    }
    
    private func overlayFirstLayer() {
        addSubview(cardView)
        
        cardView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    }
    
    private func overlayCardView() {
        cardView.addSubview(topView)
        
        topView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8).isActive = true
        topView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8).isActive = true
        topView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8).isActive = true
        topView.heightAnchor.constraint(equalToConstant: Constants.topViewHeight).isActive = true
        
        cardView.addSubview(postTextView)
        cardView.addSubview(postImageView)
        cardView.addSubview(galleryCollectionView)
        cardView.addSubview(moreTextButton)
        
        cardView.addSubview(bottomView)
    }
    
    private func overlayTopView() {
        topView.addSubview(resourceIconImageView)
        
        resourceIconImageView.heightAnchor.constraint(equalTo: topView.heightAnchor).isActive = true
        resourceIconImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        resourceIconImageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        resourceIconImageView.widthAnchor.constraint(equalTo: resourceIconImageView.heightAnchor).isActive = true
        
        topView.addSubview(resourceNameLabel)
        resourceNameLabel.topAnchor.constraint(equalTo: resourceIconImageView.topAnchor).isActive = true
        resourceNameLabel.leadingAnchor.constraint(equalTo: resourceIconImageView.trailingAnchor, constant: 8).isActive = true
        resourceNameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor).isActive = true
        resourceNameLabel.heightAnchor.constraint(equalToConstant: 21)
        
        topView.addSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: resourceNameLabel.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: resourceNameLabel.trailingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: resourceNameLabel.bottomAnchor, constant: 8).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 13)
    }
    
    private func overlayBottomView() {
        bottomView.addSubview(likesView)
        likesView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 8).isActive = true
        likesView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        likesView.heightAnchor.constraint(equalTo: bottomView.heightAnchor).isActive = true
        
        bottomView.addSubview(commentsView)
        commentsView.leadingAnchor.constraint(equalTo: likesView.trailingAnchor, constant: 8).isActive = true
        commentsView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        commentsView.heightAnchor.constraint(equalTo: bottomView.heightAnchor).isActive = true
        
        bottomView.addSubview(sharesView)
        sharesView.leadingAnchor.constraint(equalTo: commentsView.trailingAnchor, constant:  8).isActive = true
        sharesView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        sharesView.heightAnchor.constraint(equalTo: bottomView.heightAnchor).isActive = true
        
        bottomView.addSubview(viewsView)
        viewsView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -8).isActive = true
        viewsView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        viewsView.heightAnchor.constraint(equalTo: bottomView.heightAnchor).isActive = true
    }
    
    private func overlayCountViews() {
        likesView.addSubview(likesImageView)
        likesView.addSubview(likesLabel)
        
        commentsView.addSubview(commentsImageView)
        commentsView.addSubview(commentsLabel)
        
        sharesView.addSubview(sharesImageView)
        sharesView.addSubview(sharesLabel)
        
        viewsView.addSubview(viewsImageView)
        viewsView.addSubview(viewsLabel)
        
        setup(likesView, with: likesImageView, and: likesLabel)
        setup(commentsView, with: commentsImageView, and: commentsLabel)
        setup(sharesView, with: sharesImageView, and: sharesLabel)
        setup(viewsView, with: viewsImageView, and: viewsLabel)
    }
    
    private func setup(_ view: UIView, with imageView: UIImageView, and label: UILabel) {
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Constants.bottomViewIconSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.bottomViewIconSize).isActive = true
        
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func set(_ viewModel: FeedCellViewModel) {
        resourceIconImageView.kf.setImage(with: URL(string: viewModel.iconURLString))
        resourceNameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        
        postTextView.text = viewModel.text
        postTextView.frame = viewModel.sizes.postLabelFrame
        
        moreTextButton.frame = viewModel.sizes.moreTextButtonFrame
        
        if let imageUrlString = viewModel.photoAttachements.first?.photoURLString,
            viewModel.photoAttachements.count == 1 {
            postImageView.kf.indicatorType = .activity
            postImageView.kf.setImage(with: URL(string:  imageUrlString))
            postImageView.isHidden = false
            galleryCollectionView.isHidden = true
            postImageView.frame = viewModel.sizes.attachementFrame
        } else if viewModel.photoAttachements.count > 1 {
            galleryCollectionView.photos = viewModel.photoAttachements
            postImageView.isHidden = true
            galleryCollectionView.isHidden = false
            galleryCollectionView.frame = viewModel.sizes.attachementFrame
        } else {
            postImageView.isHidden = true
            galleryCollectionView.isHidden = true
        }
        
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        sharesLabel.text = viewModel.shares
        viewsLabel.text = viewModel.views
        
        bottomView.frame = viewModel.sizes.bottomViewFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
