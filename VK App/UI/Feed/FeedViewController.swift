//
//  FeedViewController.swift
//  VK App
//
//  Created by Алексей Воронов on 18.08.2019.
//  Copyright (c) 2019 Алексей Воронов. All rights reserved.
//

import UIKit

protocol FeedDisplayLogic: class {
    func displayData(viewModel: Feed.Model.ViewModel.ViewModelData)
}

class FeedViewController: UIViewController, FeedDisplayLogic {
    var interactor: FeedBusinessLogic?
    var router: (NSObjectProtocol & FeedRoutingLogic)?
    
    private var titleView: TitleView = TitleView()
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private var feedViewModel: FeedViewModel = FeedViewModel(cells: []) {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = FeedInteractor()
        let presenter             = FeedPresenter()
        let router                = FeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = refreshControl
        
        setupTopBar()
        
        tableView.separatorStyle = .none
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.reuseId)
        
        interactor?.makeRequest(request: .getNewsFeed)
    }
    
    func displayData(viewModel: Feed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case let .display(feed):
            feedViewModel = feed
            
        case let .displayUser(user):
            DispatchQueue.main.async { [weak self] in
                self?.titleView.set(userViewModel: user)
            }
        }
    }
    
    private func setupTopBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = titleView
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        interactor?.makeRequest(request: .getNewsFeed)
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.reuseId, for: indexPath) as! FeedCell
        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.set(cellViewModel)
        cell.delegate = self
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
}

extension FeedViewController: FeedCellDelegate {
    func revealPost(for cell: FeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        interactor?.makeRequest(request: .revealPostIds(postId: cellViewModel.postId))
    }
}
