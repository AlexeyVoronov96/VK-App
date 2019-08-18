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
    
    func presentData(response: Feed.Model.Response.ResponseType) {
        switch response {
        case let .present(feed):
            let cells = feed.items.map { (feedItem) in
                setupCellViewModel(from: feedItem)
            }
            let feedViewModel = FeedViewModel(cells: cells)
            viewController?.displayData(viewModel: .display(feed: feedViewModel))
        }
    }
    
    private func setupCellViewModel(from feedItem: FeedItem) -> FeedViewModel.Cell {
        return FeedViewModel.Cell(iconURLString: "",
                                  name: "name",
                                  date: "date",
                                  text: feedItem.text,
                                  likes: String(feedItem.likes?.count ?? 0),
                                  comments: String(feedItem.comments?.count ?? 0),
                                  shares: String(feedItem.reposts?.count ?? 0),
                                  views: String(feedItem.views?.count ?? 0))
    }
}
