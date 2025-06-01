//
//  CurrencyExchangeNetworkService.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import Foundation

protocol CurrencyExchangeNetworkProtocol {
    
    func fetchExchangeRate(_ model: ExchangeRequestModel) async throws(NetworkError) -> ExchangeResponse
    func fetchCurrencies() async throws(NetworkError) -> [String]
}

final class CurrencyExchangeNetworkService: NetworkService, CurrencyExchangeNetworkProtocol {
    
    func fetchExchangeRate(_ model: ExchangeRequestModel) async throws(NetworkError) -> ExchangeResponse {
        return try await client.performRequest(CurrencyExchangeProvider.Request.exchange(model: model))
    }
    
    func fetchCurrencies() async throws(NetworkError) -> [String] {
        return try await client.performRequest(CurrencyExchangeProvider.Request.getCurrencies)
    }
}
