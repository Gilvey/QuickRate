//
//  TextField+.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import UIKit

extension UITextField {
    func applyCurrencyStyle() {
        self.keyboardType = .decimalPad
        self.layer.cornerRadius = 14
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.33).cgColor
    }
}
