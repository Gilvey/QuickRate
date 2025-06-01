//
//  CurrencyExchangeProvider.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 31.05.25.
//

import Foundation

enum CurrencyExchangeProvider {
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
            path = "exchange/\(model.amount)-\(model.fromCurrency)/\(model.toCurrency)/latest"
            
        case .getCurrencies:
            path = "currencies"
        }
        return URL(string: "http://api.evp.lt/currency/commercial/" + path)
    }
}
