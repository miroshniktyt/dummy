//
//  Service.swift
//  dummy
//
//  Created by Macbook Air on 27.09.2020.
//  Copyright © 2020 macbook. All rights reserved.
//

import Foundation
import Combine

enum ServiceError: Error {
    case notConnectedToInternet
    case unknown(Error)
}

struct Service {
    static let shared = Service()
    static let pageSize = 10
    
    private let apiKey = "5f71e83f1081ba192d1fa31f"
    private let baseStringURL = "https://dummyapi.io/data/api"
        
    private func usersURLRequest(forPage page: Int) -> URLRequest? {
        let usersStrinURL = baseStringURL + "/user"
        guard var components = URLComponents(string: usersStrinURL) else { return nil }
        
        let pageParameter = URLQueryItem(name: "page", value: "\(page)")
        let limitParameter = URLQueryItem(name: "limit", value: "\(Service.pageSize)")
        components.queryItems = [limitParameter, pageParameter]
        
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "app-id")
        
        return request
    }
    
    func fetchMoreUsers(forPage page: Int) -> AnyPublisher<[UserInfo], ServiceError> {
        let request = usersURLRequest(forPage: page)! // TODO: !

        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(2)
            .map { $0.data }
            .decode(type: Users.self, decoder: JSONDecoder())
            .map { $0.data }
            .mapError { error in
                switch error {
                case URLError.notConnectedToInternet: return .notConnectedToInternet
                default: return .unknown(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
