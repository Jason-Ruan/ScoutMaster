//
//  Network.swift
//  ScoutMaster
//
//  Created by Sam Roman on 1/27/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private init() {}
    
    static let shared = NetworkManager()
    
    private let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    
    func fetchData(urlString: String,  completionHandler: @escaping (Result<Data,AppError>) -> ()) {
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
            guard error == nil else {
                completionHandler(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noDataError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.badHTTPResponse))
                return
            }
            
            switch response.statusCode {
            case 404:
                completionHandler(.failure(.notFound))
            case 401,403:
                completionHandler(.failure(.unauthorized))
            case 200...299:
                completionHandler(.success(data))
            default:
                completionHandler(.failure(.other(errorDescription: "Wrong Status Code")))
            }
            }
        }.resume()
        
    }
}
