//
//  NetworkError.swift
//  QuickRate
//
//  Created by Nikolay Gilvey on 1.06.25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(underlying: Error)
    case serverError(ServerErrorDTO)
    case decodingFailed
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "🧁 Bad recipe: The URL is invalid."
        case .requestFailed(let error):
            return "🥧 Oven broke down: Network request failed. (\(error.localizedDescription))"
        case .serverError(let error):
            return "🍰 Burnt on delivery: Server responded with code: \(error.errorDescription)."
        case .decodingFailed:
            return "🍪 Crumbled recipe: Failed to decode the response."
        case .unknown:
            return "🍩 Mystery muffin: Something unexpected happened."
        }
    }
}
