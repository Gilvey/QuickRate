//
//  APIService.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 31.05.25.
//

import Foundation

protocol APIServiceProtocol {
    
    func performRequest<T: Decodable>(_ endPoint: EndPoint) async throws -> T
    func performRequest(endPoint: EndPoint) async throws -> Void
}

final class APIService: APIServiceProtocol {
    
    static let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    private let decoder = JSONDecoder()
    
    func performRequest<T: Decodable>(_ endPoint: EndPoint) async throws -> T {
        let data = try await fetchData(for: endPoint)
        return try decode(data: data, as: T.self)
    }
    
    func performRequest(endPoint: EndPoint) async throws {
        _ = try await fetchData(for: endPoint)
        
    }
    
    private func fetchData(for endPoint: EndPoint) async throws -> Data {
        let request = try endPoint.urlRequest()
        let session = APIService.session
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw QuickRateError.default
        }
        if (200..<300).contains(httpResponse.statusCode) {
            return data
        } else {
            throw try decode(data: data, as: QuickRateError.self)
        }
    }
    
    private func decode<T:Decodable>(data: Data, as type: T.Type) throws -> T {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw QuickRateError.default
        }
    }
}
