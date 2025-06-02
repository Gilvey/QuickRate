//
//  QuickRateError.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 31.05.25.
//

import Foundation

struct ServerErrorDTO: Error, Decodable {
    let error: String
    let errorDescription: String
    
    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
}

extension ServerErrorDTO {
    static let `default` = ServerErrorDTO(error: "parse_error", errorDescription: "Oops, smth went wrong")
}
