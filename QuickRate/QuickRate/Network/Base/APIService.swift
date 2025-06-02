//
//  APIService.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 31.05.25.
//

import Foundation

protocol APIServiceProtocol {
    
    func performRequest<T: Decodable>(_ endPoint: EndPoint) async throws(NetworkError) -> T
    func performRequest(endPoint: EndPoint) async throws(NetworkError) -> Void
}

final class APIService: APIServiceProtocol {
    
    static let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    private let decoder = JSONDecoder()
    
    func performRequest<T: Decodable>(_ endPoint: EndPoint) async throws(NetworkError) -> T {
        let data = try await fetchData(for: endPoint)
        return try decode(data: data, as: T.self)
    }
    
    func performRequest(endPoint: EndPoint) async throws(NetworkError) {
        _ = try await fetchData(for: endPoint)
    }
    
    private func fetchData(for endPoint: EndPoint) async throws(NetworkError) -> Data {
        let request = try endPoint.urlRequest()
        let session = APIService.session
        
        var data = Data()
        var response = URLResponse()
        
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.requestFailed(underlying: error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError(ServerErrorDTO.default)
        }
        if (200..<300).contains(httpResponse.statusCode) {
            return data
        } else {
            throw try NetworkError.serverError(decode(data: data, as: ServerErrorDTO.self))
        }
    }
    
    private func decode<T:Decodable>(data: Data, as type: T.Type) throws(NetworkError) -> T {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
