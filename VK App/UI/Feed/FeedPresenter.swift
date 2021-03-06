//
//  FeedPresenter.swift
//  VK App
//
//  Created by Алексей Воронов on 18.08.2019.
//  Copyright (c) 2019 Алексей Воронов. All rights reserved.
//

import UIKit

protocol FeedPresentationLogic {
    func presentData(response: Feed.Model.Response.ResponseType)
}

class FeedPresenter: FeedPresentationLogic {
    weak var viewController: FeedDisplayLogic?
    
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM 'at' HH:mm"
        
        return dateFormatter
    }
    
    func presentData(response: Feed.Model.Response.ResponseType) {
        switch response {
        case let .present(feed, revealedPostIds):
            let cells = feed.items.map { (feedItem) in
                setupCellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups, revealedPostIds: revealedPostIds)
            }
            let feedViewModel = FeedViewModel(cells: cells)
            viewController?.displayData(viewModel: .display(feed: feedViewModel))
            
        case let .presentUser(user):
            let fullName = "\(user.firstName ?? "") \(user.lastName ?? "")"
            let userViewModel = UserViewModel(photoUrl: user.photo100,
                                              fullName: fullName)
            viewController?.displayData(viewModel: .displayUser(user: userViewModel))
            
        case let .presentMore(feed, revealedPostIds):
            let cells = feed.items.map { (feedItem) in
                setupCellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups, revealedPostIds: revealedPostIds)
            }
            let feedViewModel = FeedViewModel(cells: cells)
            viewController?.displayData(viewModel: .displayMore(feed: feedViewModel))
            
        case .presentFooterLoader:
            viewController?.displayData(viewModel: .displayFooterLoader)
        }
    }
    
    private func setupCellViewModel(from feedItem: FeedItem, profiles: Profiles, groups: Groups, revealedPostIds: [Int]) -> FeedViewModel.Cell {
        let profile = setupProfile(for: feedItem.sourceId, from: profiles, and: groups)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateString = dateFormatter.string(from: date)
        let photoAttachments = setupPhotoAttachments(from: feedItem)
        
        let isFullSized = revealedPostIds.contains { (postId) -> Bool in
            return postId == feedItem.postId
        }
        
        let sizes = cellLayoutCalculator.calculateSizes(postText: feedItem.text, photoAttachments: photoAttachments, isFullSized: isFullSized)
        
        let postText = feedItem.text?.replacingOccurrences(of: "<br>", with: "\n")
        
        return FeedViewModel.Cell(postId: feedItem.postId,
                                  iconURLString: profile?.photo ?? "",
                                  name: profile?.name ?? "",
                                  date: dateString,
                                  text: postText,
                                  likes: formattedCounter(feedItem.likes?.count),
                                  comments: formattedCounter(feedItem.comments?.count),
                                  shares: formattedCounter(feedItem.reposts?.count),
                                  views: formattedCounter(feedItem.views?.count),
                                  photoAttachements: photoAttachments,
                                  sizes: sizes)
    }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter,
            counter > 0 else {
                return nil
        }
        
        var counterString = String(counter)
        
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        
        return counterString
    }
    
    private func setupProfile(for sourceId: Int, from profiles: Profiles, and groups: Groups) -> ProfileRepresantable? {
        let profilesOrGroups: [ProfileRepresantable] = sourceId > 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        
        return profilesOrGroups.first { (myProfileRepresentable) -> Bool in
            return myProfileRepresentable.id == normalSourceId
        }
    }
    
    private func setupPhotoAttachments(from item: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachement] {
        guard let attachments = item.attachments else { return [] }
        
        return attachments.compactMap({ (attachment) -> FeedViewModel.FeedCellPhotoAttachement? in
            guard let photo = attachment.photo else { return nil }
            return FeedViewModel.FeedCellPhotoAttachement(photoURLString: photo.url,
                                                          height: photo.height,
                                                          width: photo.width)
        })
    }
}
