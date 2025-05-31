//
//  EndPoint.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 31.05.25.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

protocol EndPoint {
    var url: URL? { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

extension EndPoint {
    
    var httpMethod: HTTPMethod {
        HTTPMethod.get
    }
    
    var headers: [String: String]? {
        nil
    }
    
    var body: Data? {
        nil
    }

    func urlRequest() throws -> URLRequest {
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            request.httpBody = body
            request.allHTTPHeaderFields = headers
            return request
        } else {
            throw QuickRateError(error: "invalid_url", errorDescription: "Wrong url")
        }
    }
}
