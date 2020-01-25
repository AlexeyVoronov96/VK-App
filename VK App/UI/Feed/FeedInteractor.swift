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
    private var networkService = NetworkService<VKAPIRoute>()
    
    var presenter: FeedPresentationLogic?
    var service: FeedService?
    
    private var revealedPostIds: [Int] = []
    private var feedResponse: FeedResponse?
    private var userResponse: UserResponse?
    
    func makeRequest(request: Feed.Model.Request.RequestType) {
        if service == nil {
            service = FeedService()
        }
        
        switch request {
        case .getNewsFeed:
            networkService.getData(with: .getFeed(nextFrom: nil), type: FeedResponseWrapped.self) { [weak self] result in
                switch result {
                case let .success(responseModel):
                    self?.feedResponse = responseModel.response
                    self?.revealedPostIds.removeAll()
                    self?.presentFeed()
                    
                case .failure:
                    break
                }
            }
            
        case let .revealPostIds(postId):
            revealedPostIds.append(postId)
            presentFeed()
            
        case .getUser:
            networkService.getData(with: .getUser, type: UserResponseWrapped.self) { [weak self] result in
                switch result {
                case let .success(responseModel):
                    self?.userResponse = responseModel.response.first
                    self?.presentUserAvatar()
                    
                case .failure:
                    break
                }
            }
            
        case .getNextBatch:
            guard let nextFrom = feedResponse?.nextFrom else { return }
            presenter?.presentData(response: .presentFooterLoader)
            networkService.getData(with: .getFeed(nextFrom: nextFrom), type: FeedResponseWrapped.self) { [weak self] result in
                switch result {
                case let .success(responseModel):
                    self?.feedResponse = responseModel.response
                    self?.presentMoreFeed()
                    
                case .failure:
                    break
                }
            }
        }
    }
    
    private func presentFeed() {
        guard let feedResponse = feedResponse else { return }
        presenter?.presentData(response: .present(feed: feedResponse, revealedPostIds: revealedPostIds))
    }
    
    private func presentMoreFeed() {
        guard let feedResponse = feedResponse else { return }
        presenter?.presentData(response: .presentMore(feed: feedResponse, revealedPostIds: revealedPostIds))
    }
    
    private func presentUserAvatar() {
        guard let userResponse = userResponse else { return }
        presenter?.presentData(response: .presentUser(user: userResponse))
    }
}
