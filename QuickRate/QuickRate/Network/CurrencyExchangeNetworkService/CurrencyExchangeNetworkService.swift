//
//  CurrencyExchangeNetworkService.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import Foundation

protocol CurrencyExchangeNetworkProtocol {
    
    func fetchExchangeRate(
        for amount: String,
        from fromCurrency: String,
        to toCurrency: String
    ) async throws -> String
}

final class CurrencyExchangeNetworkService: CurrencyExchangeNetworkProtocol {
    
    func fetchExchangeRate(
        for amount: String,
        from fromCurrency: String,
        to toCurrency: String
    ) async throws -> String {
        let urlString = "http://api.evp.lt/currency/commercial/exchange/\(amount)-\(fromCurrency)/\(toCurrency)/latest"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode(ExchangeResponse.self, from: data)
        
        return result.amount
    }
}
