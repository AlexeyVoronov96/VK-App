//
//  NetworkService.swift
//  VK App
//
//  Created by Алексей Воронов on 18.08.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import Foundation

final class NetworkService<Route: APIRoute> {
    
    func getData<T: Decodable>(with request: Route, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = perform(request) else {
            completion(.failure(NetworkServiceErrors.requestError))
            return
        }
        
        loadData(with: request) { [weak self] (data, error) in
            guard let self = self else {
                completion(.failure(NetworkServiceErrors.internalInconsistency))
                return
            }
            
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                completion(.failure(NetworkServiceErrors.dataNil))
                return
            }
            
            let result = Result {
                try self.parse(with: type, from: data)
            }
            
            completion(result)
        }
    }
}

private extension NetworkService {
    
    private func perform(_ request: Route) -> URLRequest? {
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
        
        return URLRequest(url: url)
    }
    
    private func loadData(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            completion(data, error)
        }.resume()
    }
    
    private func parse<T: Decodable>(with type: T.Type, from data: Data) throws -> T {
        let jsonDecoder = JSONDecoder()
        
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try jsonDecoder.decode(type, from: data)
    }
}
