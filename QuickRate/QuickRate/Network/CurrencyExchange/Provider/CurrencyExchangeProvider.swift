//
//  CurrencyExchangeProvider.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 31.05.25.
//

import Foundation

enum CurrencyExchangeProvider {
    enum Path {
        static let baseURL = "http://api.evp.lt/"
        static let latest = "latest"
        static let commercial = "currency/commercial/exchange"
    }
    
    enum Request {
        case exchange(model: ExchangeRequestModel)
    }
}

extension CurrencyExchangeProvider.Request: EndPoint {
    var url: URL? {
        switch self {
        case .exchange(let model):
            let path = "\(CurrencyExchangeProvider.Path.commercial)/\(model.amount)-\(model.fromCurrency)/\(model.toCurrency)/\(CurrencyExchangeProvider.Path.latest)"
//            http://api.evp.lt/currency/commercial/exchange/340.51-EUR/ABC/latest
            print(CurrencyExchangeProvider.Path.baseURL + path)
            return URL(string: CurrencyExchangeProvider.Path.baseURL + path)
        }
    }
}
