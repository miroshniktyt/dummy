//
//  UsersListViewModel.swift
//  dummy
//
//  Created by Macbook Air on 27.09.2020.
//  Copyright © 2020 macbook. All rights reserved.
//

import Combine

class UsersListViewModel: ObservableObject {
        
    enum State {
        case active
        case didLoadLastPage
        case error(ServiceError)
    }
    
    @Published var state: State = .active
    @Published var users = [UserInfo]()
    
    private var currentPage = 1
    private var subscriptions = Set<AnyCancellable>()
        
    func fetchMoreUsers() {
        if case .didLoadLastPage = state { return } // TODO: Maybe confirm to Equatable?

        Service.shared.fetchMoreUsers(forPage: currentPage)
            .sink(receiveCompletion: didReceiveCompletion,
                  receiveValue: didReceiveValue)
            .store(in: &subscriptions)
    }
    
    private func didReceiveCompletion(_ completion: Subscribers.Completion<ServiceError>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
            state = .error(error)
        }
    }
    
    private func didReceiveValue(_ value: [UserInfo]) {
        users += value
        currentPage += 1
        if value.count != Service.pageSize {
            print("Reached the last page")
            state = .didLoadLastPage
        }
    }
        
}
