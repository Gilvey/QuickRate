//
//  CurrencyConverterState.swift
//  QuickRate
//
//  Created by Nikolay Gilvey on 31.05.25.
//

import Foundation

struct CurrencyConverterState {
    var convertedValue: String = ""
    var errorMessage: String?
    var currencies: [String]?
    var isLoading: Bool = false
    var switchedCurrencies: (String, String)?
}
