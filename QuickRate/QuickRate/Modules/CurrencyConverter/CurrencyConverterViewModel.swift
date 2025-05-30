//
//  CurrencyConverterViewModel.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import Foundation

final class CurrencyConverterViewModel {
    
    @Published var convertedValue: String = ""
    @Published var errorMessage: String?
    
    var currencyOptions = ["USD", "BYN", "EUR", "RUB"]
    var fromCurrency: String = "BYN"
    var toCurrency: String = "USD"
    
    private let currencyExchangeService: CurrencyExchangeNetworkProtocol
    
    init(currencyExchangeService: CurrencyExchangeNetworkProtocol) {
        self.currencyExchangeService = currencyExchangeService
    }
    
    func getExchangeRate(for amount: String) {
        guard !amount.isEmpty else { return  }
        Task {
            do {
                convertedValue = try await currencyExchangeService.fetchExchangeRate(for: amount, from: fromCurrency, to: toCurrency)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
