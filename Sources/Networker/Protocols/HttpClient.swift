//
//  HttpClient.swift
//  Offers
//
//  Created by Praveen K Velanati on 3/26/23.
//

import Foundation
import Combine

public protocol HTTPClient {
    func requestResponse<T: Decodable>(endPoint: HTTPEndpoint, responseModel: T.Type) -> AnyPublisher<T, RequestError>
    func requestResponse<T: Decodable>(endPoint: HTTPEndpoint, responseModel: T.Type) async -> Result<T, RequestError>
    func requestResponse<T: Decodable>(endPoint: HTTPEndpoint, responseModel: T.Type, completion: @escaping (Result<T, RequestError>) -> Void)
}


