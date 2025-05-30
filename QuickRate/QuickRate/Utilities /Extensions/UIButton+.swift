//
//  UIButton+.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import UIKit

extension UIButton {
    func applyCurrencyButtonStyle() {
        self.layer.cornerRadius = 8
        self.backgroundColor = .systemGray6
        self.setTitleColor(.black, for: .normal)
    }

    func applySwitchButtonStyle() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.33).cgColor
    }
}
