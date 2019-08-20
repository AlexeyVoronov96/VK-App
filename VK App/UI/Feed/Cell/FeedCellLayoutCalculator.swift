//
//  FeedCellLayoutCalculator.swift
//  VK App
//
//  Created by Алексей Воронов on 19.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import UIKit

protocol FeedCellLayoutCalculatorProtocol {
    func calculateSizes(postText: String?, photoAttachments: [FeedCellPhotoAttachementViewModel], isFullSized: Bool) -> FeedCellSizes
}

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var attachementFrame: CGRect
    var moreTextButtonFrame: CGRect
    var bottomViewFrame: CGRect
    
    var totalHeight: CGFloat
}

struct Constants {
    static let cardInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    static let topViewInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    static let topViewHeight: CGFloat = 42
    static let postLabelInsets = UIEdgeInsets(top: 8 + topViewHeight + 8,
                                              left: 8,
                                              bottom: 8,
                                              right: 8)
    static let postLabelFont = UIFont.systemFont(ofSize: 17)
    static let bottomViewHeight: CGFloat = 60
    static let bottomViewIconSize: CGFloat = 24
    static let minifiedPostLimitLines: CGFloat = 8
    static let minifiedPostLines: CGFloat = 6
    static let moreTextButtonInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    static let moreTextButtonSize: CGSize = CGSize(width: 170, height: 30)
}

final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func calculateSizes(postText: String?, photoAttachments: [FeedCellPhotoAttachementViewModel], isFullSized: Bool) -> FeedCellSizes {
        var showMoreTextButton = false
        
        let cardViewWidth = screenWidth - Constants.cardInsets.left - Constants.cardInsets.right
        
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelInsets.left,
                                                    y: Constants.postLabelInsets.top),
                                    size: .zero)
        
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - Constants.postLabelInsets.left - Constants.postLabelInsets.right
            var height = text.height(width: width, font: Constants.postLabelFont)
            
            let limitHeight = Constants.postLabelFont.lineHeight * Constants.minifiedPostLimitLines
            
            if !isFullSized, height > limitHeight {
                height = Constants.postLabelFont.lineHeight * Constants.minifiedPostLines
                showMoreTextButton = true
            }
            
            postLabelFrame.size = CGSize(width: width, height: height)
        } else {
            postLabelFrame.size = .zero
        }
        
        var moreTextButtonSize: CGSize = .zero
        if showMoreTextButton {
            moreTextButtonSize = Constants.moreTextButtonSize
        }
        
        let moreTextButtonOrigin = CGPoint(x: Constants.moreTextButtonInsets.left,
                                           y: postLabelFrame.maxY)
        
        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTextButtonSize)
        
        let attachmentTop = postLabelFrame.size == .zero ? Constants.postLabelInsets.top : moreTextButtonFrame.maxY + Constants.postLabelInsets.bottom
        
        var attachmentFrame = CGRect(origin: CGPoint(x: 0,
                                                     y: attachmentTop),
                                     size: .zero)
        
        if let attachment = photoAttachments.first {
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width)
            let ratio = CGFloat(photoHeight / photoWidth)
            
            if photoAttachments.count == 1 {
                attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ratio)
            } else if photoAttachments.count > 1 {
                var photos: [CGSize] = []
                for photo in photoAttachments {
                    let photoSize = CGSize(width: photo.width, height: photo.height)
                    photos.append(photoSize)
                }
                
                let rowHeight = RowLayout.rowHeightCounter(superviewWidth: cardViewWidth, photosArray: photos)
                attachmentFrame.size = CGSize(width: cardViewWidth, height: rowHeight!)
            }
        }
        
        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0,
                                                     y: bottomViewTop),
                                     size: CGSize(width: cardViewWidth,
                                                  height: Constants.bottomViewHeight))
        
        let totalHeight = bottomViewFrame.maxY + Constants.cardInsets.bottom
        
        return Sizes(postLabelFrame: postLabelFrame,
                     attachementFrame: attachmentFrame,
                     moreTextButtonFrame: moreTextButtonFrame,
                     bottomViewFrame: bottomViewFrame,
                     totalHeight: totalHeight)
    }
}
