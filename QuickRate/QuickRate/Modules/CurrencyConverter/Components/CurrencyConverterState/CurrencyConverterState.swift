//
//  CurrencyConverterState.swift
//  QuickRate
//
//  Created by Nikolay Gilvey on 31.05.25.
//

import Foundation

struct CurrencyConverterState {
    var convertedValue: String
    var errorMessage: String?
    
    init(convertedValue: String = "", errorMessage: String? = nil) {
        self.convertedValue = convertedValue
        self.errorMessage = errorMessage
    }
    
    func with(convertedValue: String? = nil, errorMessage: String? = nil) -> CurrencyConverterState {
        return CurrencyConverterState(
            convertedValue: convertedValue ?? "",
            errorMessage: errorMessage ?? nil
        )
    }
}
