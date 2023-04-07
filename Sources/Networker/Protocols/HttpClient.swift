//
//  HttpClient.swift
//  Offers
//
//  Created by Praveen K Velanati on 3/26/23.
//

import Foundation
import Combine

protocol HTTPClient {
    func requestResponse<T: Decodable>(endPoint: HTTPEndpoint, responseModel: T.Type) -> AnyPublisher<T, RequestError>
}

extension HTTPClient {
    func requestResponse<T: Decodable>(endPoint: HTTPEndpoint, responseModel: T.Type) -> AnyPublisher<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        urlComponents.query = "q=Nike shoes&country=us&language=en"
        
        guard let url = urlComponents.url else {
            return Fail(error: RequestError.invalidURL).eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endPoint.headers
        if let body = endPoint.body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .mapError({ _ in
                return RequestError.unknown
            })
            .tryMap { result in
                return try JSONDecoder().decode(responseModel.self, from: result.data)
            }
            .catch({ _ in
                return Fail(error: RequestError.invalidURL)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
