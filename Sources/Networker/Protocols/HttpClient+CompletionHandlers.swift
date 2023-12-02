//
//  File.swift
//  
//
//  Created by Praveen K Velanati on 4/6/23.
//

import Foundation

public extension HTTPClient {
    
    func requestResponse<T: Decodable>(endPoint: HTTPEndpoint, responseModel: T.Type, completion: @escaping (Result<T, RequestError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        urlComponents.queryItems = endPoint.queryItems
        
        guard let url = urlComponents.url else {
            return completion(.failure(.invalidURL))
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endPoint.headers
        if let body = endPoint.body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse, let data = data else {
                return completion(.failure(.noResponse))
            }
            guard error == nil else {
                return completion(.failure(.unknown))
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel.self, from: data) else {
                    return completion(.failure(.decode))
                }
                return completion(.success(decodedResponse))
            case 401:
                return completion(.failure(.unauthorized))
            default:
                return completion(.failure(.unknown))
            }
        }
    }
}
