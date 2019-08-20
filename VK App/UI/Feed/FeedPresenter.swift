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
        }
    }
    
    private func setupCellViewModel(from feedItem: FeedItem, profiles: Profiles, groups: Groups, revealedPostIds: [Int]) -> FeedViewModel.Cell {
        let profile = setupProfile(for: feedItem.sourceId, from: profiles, and: groups)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateString = dateFormatter.string(from: date)
        let photoAttachment = setupPhotoAttachement(from: feedItem)
        
        let isFullSized = revealedPostIds.contains { (postId) -> Bool in
            return postId == feedItem.postId
        }
        
        let sizes = cellLayoutCalculator.calculateSizes(postText: feedItem.text, photoAttachment: photoAttachment, isFullSized: isFullSized)
        
        return FeedViewModel.Cell(postId: feedItem.postId,
                                  iconURLString: profile?.photo ?? "",
                                  name: profile?.name ?? "",
                                  date: dateString,
                                  text: feedItem.text,
                                  likes: String(feedItem.likes?.count ?? 0),
                                  comments: String(feedItem.comments?.count ?? 0),
                                  shares: String(feedItem.reposts?.count ?? 0),
                                  views: String(feedItem.views?.count ?? 0),
                                  photoAttachement: photoAttachment,
                                  sizes: sizes)
    }
    
    private func setupProfile(for sourceId: Int, from profiles: Profiles, and groups: Groups) -> ProfileRepresantable? {
        let profilesOrGroups: [ProfileRepresantable] = sourceId > 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        
        return profilesOrGroups.first { (myProfileRepresentable) -> Bool in
            return myProfileRepresentable.id == normalSourceId
        }
    }
    
    private func setupPhotoAttachement(from item: FeedItem) -> FeedViewModel.FeedCellPhotoAttachement? {
        guard let photos = item.attachments?.compactMap({ $0.photo }),
            let firstPhoto = photos.first else {
                return nil
        }
        
        return FeedViewModel.FeedCellPhotoAttachement(photoURLString: firstPhoto.url,
                                                      height: firstPhoto.height,
                                                      width: firstPhoto.width)
    }
}