//
//  NetworkService.swift
//  QuickRate
//
//  Created by Nikolay Gilvey on 31.05.25.
//

import Foundation

class NetworkService {
    
    var client: APIServiceProtocol {
        APIService()
    }
}
