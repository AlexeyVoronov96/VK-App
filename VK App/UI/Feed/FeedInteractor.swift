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
    
    func makeRequest(request: Feed.Model.Request.RequestType) {
        if service == nil {
            service = FeedService()
        }
        
        switch request {
        case .getNewsFeed:
            networkService.getData(with: .getFeed, type: FeedResponseWrapped.self) { [weak self] (feedResponse, error) in
                    guard let feedResponse = feedResponse else {
                        return
                    }
                    self?.presenter?.presentData(response: .present(feed: feedResponse.response))
            }
        }
    }
    
}
