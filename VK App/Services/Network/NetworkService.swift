//
//  NetworkService.swift
//  VK App
//
//  Created by Алексей Воронов on 18.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func getData<T: Decodable>(with request: Requests, type: T.Type, completion: @escaping (T?, Error?) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    static let shared: NetworkService = NetworkService()
    
    func getData<T: Decodable>(with request: Requests, type: T.Type, completion: @escaping (T?, Error?) -> Void) {
        guard let request = perform(request) else {
            return
        }
        
        loadData(with: request) { [weak self] (data, error) in
            if let error = error {
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let parsedData = self?.parse(with: type, from: data) else {
                return
            }
            
            completion(parsedData, nil)
        }
    }
    
    private func perform(_ request: Requests) -> URLRequest? {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = request.host
        components.path = request.path
        components.queryItems = request.params.map({ (param) -> URLQueryItem in
            return URLQueryItem(name: param.key, value: param.value)
        })
        
        guard let url = components.url else {
            return nil
        }
        print(url.absoluteString)
        return URLRequest(url: url)
    }
    
    private func loadData(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            completion(data, error)
        }.resume()
    }
    
    private func parse<T: Decodable>(with type: T.Type, from data: Data) -> T? {
        return try? JSONDecoder().decode(type, from: data)
    }
}
