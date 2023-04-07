//
//  HttpEndpoint.swift
//  Offers
//
//  Created by Praveen K Velanati on 3/26/23.
//

import Foundation

public protocol HTTPEndpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var body: [String: String]? { get }
    var headers: [String: String]? { get }
    var method: RequestMethod { get }
}
