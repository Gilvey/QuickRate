//
//  CurrencyExchangeProvider.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 31.05.25.
//

import Foundation

enum CurrencyExchangeProvider {
    enum Path {
        static let baseURL = "http://api.evp.lt/currency/commercial/"
        static let latest = "latest"
        static let exchange = "exchange"
        static let currencies = "currencies"
    }
    
    enum Request {
        case exchange(model: ExchangeRequestModel)
        case getCurrencies
    }
}

extension CurrencyExchangeProvider.Request: EndPoint {
    var url: URL? {
        var path = ""
        switch self {
        case .exchange(let model):
            path = "\(CurrencyExchangeProvider.Path.exchange)/\(model.amount)-\(model.fromCurrency)/\(model.toCurrency)/\(CurrencyExchangeProvider.Path.latest)"
            
        case .getCurrencies:
            path = CurrencyExchangeProvider.Path.currencies
        }
        return URL(string: CurrencyExchangeProvider.Path.baseURL + path)
    }
}
