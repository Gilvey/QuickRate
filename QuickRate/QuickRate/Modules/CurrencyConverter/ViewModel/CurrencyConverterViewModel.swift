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
    
    func send(_ event: CurrencyConverterEvent)
}

final class CurrencyConverterViewModel: CurrencyConverterViewModelProtocol {
    
    let state = PassthroughSubject<CurrencyConverterState, Never>()
    
    var currencyOptions: [String] = []
    private(set) var fromCurrency: String = ""
    private(set) var toCurrency: String = ""
    private var currentAmount: String = ""
    private var timer: Timer?
    
    private let currencyExchangeService: CurrencyExchangeNetworkProtocol
    
    init(currencyExchangeService: CurrencyExchangeNetworkProtocol) {
        self.currencyExchangeService = currencyExchangeService
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func send(_ event: CurrencyConverterEvent) {
        switch event {
        case .amountChanged(let string):
            currentAmount = string
            getExchangeRate(for: string)
        case .switchCurrencies(let currentAmount):
            swap(&fromCurrency, &toCurrency)
            getExchangeRate(for: currentAmount)
            let newState = CurrencyConverterState(switchedCurrencies: (fromCurrency, toCurrency))
            state.send(newState)
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
                currencyOptions = try await currencyExchangeService.fetchCurrencies().sorted()
                currencyOptions.append("TEST")
                fromCurrency = currencyOptions.first ?? ""
                toCurrency = currencyOptions.dropFirst().first ?? ""
                state.send(CurrencyConverterState(currencies: currencyOptions, isLoading: false))
            } catch {
                updateErrorMessage(message: error.localizedDescription)
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
            } catch {
                updateErrorMessage(message: error.localizedDescription)
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
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            guard let self = self, !self.currentAmount.isEmpty else { return }
            self.getExchangeRate(for: currentAmount)
        }
    }
}
