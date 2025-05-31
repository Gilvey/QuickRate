//
//  CurrencyExchangeNetworkService.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import Foundation

protocol CurrencyExchangeNetworkProtocol {
    
    func fetchExchangeRate(_ model: ExchangeRequestModel) async throws -> ExchangeResponse
}

final class CurrencyExchangeNetworkService: NetworkService, CurrencyExchangeNetworkProtocol {
    
    func fetchExchangeRate(_ model: ExchangeRequestModel) async throws -> ExchangeResponse {
        return try await client.performRequest(CurrencyExchangeProvider.Request.exchange(model: model))
    }
}
