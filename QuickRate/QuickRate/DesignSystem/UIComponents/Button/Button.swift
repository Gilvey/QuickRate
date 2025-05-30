//
//  Button.swift
//  QuickRate
//
//  Created by Николай Гильвей on 30.05.25.
//

import UIKit

enum ButtonStyle {
    case currencyButton
    case switchButton
}

class Button: UIButton {
    
    private var type: ButtonStyle
    
    init(type: ButtonStyle) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }
    
    init(type: ButtonStyle, image: UIImage) {
        self.type = type
        super.init(frame: .zero)
        self.setImage(image, for: .normal)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 8
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        tintColor = .black
        
        switch type {
        case .currencyButton:
            backgroundColor = .systemGray6
            setTitleColor(.black, for: .normal)
        case .switchButton:
            backgroundColor = .clear
            layer.borderWidth = 1
            layer.borderColor = UIColor.lightGray.withAlphaComponent(0.33).cgColor
        }
    }
}


