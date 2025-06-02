//
//  File.swift
//  QuickRate
//
//  Created by Nikolay Gilvey on 31.05.25.
//

import Foundation

enum CurrencyConverterEvent {
    case amountChanged(String)
    case switchCurrencies(currentAmount: String)
    case selectCurrency(type: ButtonTag, value: String, currentAmount: String)
    case fetchCurrencies
}
