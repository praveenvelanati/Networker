//
//  File.swift
//  
//
//  Created by Praveen K Velanati on 4/6/23.
//

import Foundation

public extension HTTPClient {
    func requestResponse<T: Decodable>(endPoint: HTTPEndpoint, responseModel: T.Type) async -> Result<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        urlComponents.query = "q=Nike shoes&country=us&language=en"
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endPoint.headers
        if let body = endPoint.body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            // check for status code
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unknown)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
