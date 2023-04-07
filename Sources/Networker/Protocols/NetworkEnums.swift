//
//  NetworkEnums.swift
//  Offers
//
//  Created by Praveen K Velanati on 3/26/23.
//

import Foundation

public enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
}

public enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}
