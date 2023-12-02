//
//  File.swift
//  
//
//  Created by Praveen K Velanati on 4/6/23.
//

import Foundation
import Combine

public extension HTTPClient {
    func requestResponse<T: Decodable>(endPoint: HTTPEndpoint, responseModel: T.Type) -> AnyPublisher<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        urlComponents.queryItems = endPoint.queryItems
        
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
            .tryMap { (data, urlResponse) -> Data in
                // check for status code in urlResponse and throw error if it is not 200
                return data
            }
            .decode(type: responseModel.self, decoder: JSONDecoder())
            .mapError({ error -> RequestError in
                switch error{
                case is URLError:
                    return .noResponse
                case is DecodingError:
                    return .decode
                default:
                    return error as? RequestError ?? .unknown
                }
            })
            .eraseToAnyPublisher()
    }
}
