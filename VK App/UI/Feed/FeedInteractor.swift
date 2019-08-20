//
//  FeedInteractor.swift
//  VK App
//
//  Created by Алексей Воронов on 18.08.2019.
//  Copyright (c) 2019 Алексей Воронов. All rights reserved.
//

import UIKit

protocol FeedBusinessLogic {
    func makeRequest(request: Feed.Model.Request.RequestType)
}

class FeedInteractor: FeedBusinessLogic {
    private var networkService: NetworkServiceProtocol = NetworkService.shared
    
    var presenter: FeedPresentationLogic?
    var service: FeedService?
    
    private var revealedPostIds: [Int] = []
    private var feedResponse: FeedResponse?
    
    func makeRequest(request: Feed.Model.Request.RequestType) {
        if service == nil {
            service = FeedService()
        }
        
        switch request {
        case .getNewsFeed:
            networkService.getData(with: .getFeed, type: FeedResponseWrapped.self) { [weak self] (feedResponse, error) in
                self?.feedResponse = feedResponse?.response
                self?.revealedPostIds.removeAll()
                self?.presentFeed()
            }
            
        case let .revealPostIds(postId):
            revealedPostIds.append(postId)
            presentFeed()
        }
    }
    
    private func presentFeed() {
        guard let feedResponse = feedResponse else { return }
        presenter?.presentData(response: .present(feed: feedResponse, revealedPostIds: revealedPostIds))
    }
}
