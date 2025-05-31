//
//  CurrencyConverterViewModel.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import Foundation
import Combine

protocol CurrencyConverterViewModelProtocol: AnyObject {
    var state: PassthroughSubject<CurrencyConverterState, Never> { get }
    var currencyOptions: [String] { get }
    var fromCurrency: String { get }
    var toCurrency: String { get }
    
    func send(_ event: CurrencyConverterEvent)
}

final class CurrencyConverterViewModel: CurrencyConverterViewModelProtocol {
    
    let state = PassthroughSubject<CurrencyConverterState, Never>()
    
    var currencyOptions: [String] = []
    private(set) var fromCurrency: String = ""
    private(set) var toCurrency: String = ""
    
    private let currencyExchangeService: CurrencyExchangeNetworkProtocol
    
    init(currencyExchangeService: CurrencyExchangeNetworkProtocol) {
        self.currencyExchangeService = currencyExchangeService
    }
    
    func send(_ event: CurrencyConverterEvent) {
        switch event {
        case .amountChanged(let string):
            getExchangeRate(for: string)
        case .switchCurrencies(let currentAmount):
            swap(&fromCurrency, &toCurrency)
            getExchangeRate(for: currentAmount)
        case .selectCurrency(let type, let value, let currentAmount):
            switch type {
            case .from:
                fromCurrency = value
            case .to:
                toCurrency = value
            }
            getExchangeRate(for: currentAmount)
        case .fetchCurrencies:
            fetchCurrencies()
        }
    }
    
    private func fetchCurrencies() {
        state.send(.init(isLoading: true))
        Task {
            do {
                currencyOptions = try await currencyExchangeService.fetchCurrencies()
                fromCurrency = currencyOptions.first ?? "BYN"
                toCurrency = currencyOptions.dropFirst().first ?? "USD"
                state.send(CurrencyConverterState(currencies: currencyOptions, isLoading: false))
            } catch let error as QuickRateError {
                updateErrorMessage(message: error.errorDescription)
            }
        }
    }
    
    private func getExchangeRate(for amount: String) {
        guard !amount.isEmpty else {
            updateConvertedValue(value: "")
            return
        }
        state.send(.init(convertedValue: "...", isLoading: true))
        
        let model = ExchangeRequestModel(
            amount: amount,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency
        )
        Task {
            do {
                let response = try await currencyExchangeService.fetchExchangeRate(model)
                updateConvertedValue(value: response.amount)
            } catch let error as QuickRateError {
                updateErrorMessage(message: error.errorDescription)
            }
        }
    }
    
    private func updateErrorMessage(message: String) {
        let newState = CurrencyConverterState(errorMessage: message, isLoading: false)
        state.send(newState)
    }
    
    private func updateConvertedValue(value: String) {
        let newState = CurrencyConverterState(convertedValue: value, isLoading: false)
        state.send(newState)
    }
}
