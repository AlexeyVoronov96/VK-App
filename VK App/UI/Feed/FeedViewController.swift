//
//  FeedViewController.swift
//  VK App
//
//  Created by Алексей Воронов on 18.08.2019.
//  Copyright (c) 2019 Алексей Воронов. All rights reserved.
//

import UIKit

protocol FeedViewControllerDelegate: class {
    func logout()
}

protocol FeedDisplayLogic: class {
    func displayData(viewModel: Feed.Model.ViewModel.ViewModelData)
}

class FeedViewController: UIViewController, FeedDisplayLogic {
    var interactor: FeedBusinessLogic?
    var router: (NSObjectProtocol & FeedRoutingLogic)?
    
    weak var delegate: FeedViewControllerDelegate!
    
    private var titleView: TitleView = TitleView()
    private var footerView = FooterView()
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private var feedViewModel: FeedViewModel = FeedViewModel(cells: []) {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.footerView.set(title: "\(self?.feedViewModel.cells.count ?? 0) записей")
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        let topInset: CGFloat = 8
        tableView.contentInset.top = topInset
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = refreshControl
        
        setupTopBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.reuseId)
        
        tableView.tableFooterView = footerView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        interactor?.makeRequest(request: .getNewsFeed)
        interactor?.makeRequest(request: .getUser)
    }
    
    func displayData(viewModel: Feed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case let .display(feed):
            feedViewModel = feed
            
        case let .displayUser(user):
            DispatchQueue.main.async { [weak self] in
                self?.titleView.set(userViewModel: user)
            }
            
        case let .displayMore(feed):
            feedViewModel.cells += feed.cells
            
        case .displayFooterLoader:
            footerView.showLoader()
        }
    }
    
    private func setupTopBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = titleView
        titleView.delegate = self
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

extension FeedViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.makeRequest(request: .getNextBatch)
        }
    }
}

extension FeedViewController: FeedCellDelegate {
    func revealPost(for cell: FeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        interactor?.makeRequest(request: .revealPostIds(postId: cellViewModel.postId))
    }
}

extension FeedViewController: TitleViewDelegate {
    func logout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { [delegate] (_) in
            delegate?.logout()
        }))
        
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
