//
//  UsersListView.swift
//  dummy
//
//  Created by Macbook Air on 27.09.2020.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class UsersListView: UITableViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let numberOfRowBeforeFetchingMore = Service.pageSize / 2
    
    private let viewModel = UsersListViewModel()
    
    private let spiner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindToViewModel()
        viewModel.fetchMoreUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.deselectAllRows()
    }
    
    func bindToViewModel() {
        let usersValueHandler: ([UserInfo]) -> Void = { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        viewModel.$users
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: usersValueHandler)
            .store(in: &subscriptions)
        
        let stateValueHandler: (UsersListViewModel.State) -> Void = { [weak self] state in
            switch state {
            case .active:
                //                self?.tableView.tableFooterView?.isHidden = false
                self?.spiner.startAnimating()
            case .didLoadLastPage:
                //                self?.tableView.tableFooterView?.isHidden = true
                self?.spiner.stopAnimating()
            case .error(let error):
                self?.handleError(error)
            }
        }
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &subscriptions)
    }
    
    func setupUI() {
        title = "All Users"

        spiner.frame = .init(x: 0, y: 0, width: 44, height: 44)
        spiner.startAnimating()
        
        tableView.tableFooterView = spiner
        tableView.separatorStyle = .none
        tableView.register(ProfileCell.self, forCellReuseIdentifier: NSStringFromClass(ProfileCell.self))
    }
    
    private func handleError(_ error: ServiceError) {
        switch error {
        case .notConnectedToInternet:
            presentNoInternetAlert()
        case .unknown(let error):
            presentUnknownAlert(error)
        }
    }
    
    private func presentNoInternetAlert() {
        let alertController = UIAlertController(title: "No internet", message: "Check your connection or try again later", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Try again", style: .cancel) { [weak self] _ in
            self?.viewModel.fetchMoreUsers()
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentUnknownAlert(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: TableView dataSource, delegate

extension UsersListView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.users.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ProfileCell.self), for: indexPath) as! ProfileCell
        let user = viewModel.users[indexPath.row]
        cell.userInfo = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.users[indexPath.row]
        let image = (tableView.cellForRow(at: indexPath) as? ProfileCell)?.profileImage
        let viewModel = ProfileViewModel(user: user, image: image)
        let profileView = ProfileView(viewModel: viewModel)
        let vc = UIHostingController(rootView: profileView)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isInTheEndOfSection = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 - numberOfRowBeforeFetchingMore
        let isLastSection = indexPath.section == tableView.numberOfSections - 1
        
        if isLastSection && isInTheEndOfSection {
            viewModel.fetchMoreUsers()
        }
    }
}
