//
//  CurrencyExchangeNetworkService.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import Foundation

protocol CurrencyExchangeNetworkProtocol {
    
    func fetchExchangeRate(_ model: ExchangeRequestModel) async throws -> ExchangeResponse
    func fetchCurrencies() async throws -> [String]
}

final class CurrencyExchangeNetworkService: NetworkService, CurrencyExchangeNetworkProtocol {
    
    func fetchExchangeRate(_ model: ExchangeRequestModel) async throws -> ExchangeResponse {
        return try await client.performRequest(CurrencyExchangeProvider.Request.exchange(model: model))
    }
    
    func fetchCurrencies() async throws -> [String] {
        return try await client.performRequest(CurrencyExchangeProvider.Request.getCurrencies)
    }
}
