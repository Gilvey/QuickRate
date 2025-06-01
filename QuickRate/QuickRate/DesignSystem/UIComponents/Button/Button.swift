//
//  Button.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import UIKit

enum ButtonStyle {
    case currencyButton
    case switchButton
}

final class Button: UIButton {
    
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
        tintColor = ColorManager.neutralBlack
        
        switch type {
        case .currencyButton:
            backgroundColor = ColorManager.blue
            setTitleColor(ColorManager.neutralWhite, for: .normal)
        case .switchButton:
            backgroundColor = ColorManager.neutralWhite
            tintColor = ColorManager.blue
            layer.borderWidth = 1
            layer.borderColor = ColorManager.grayTertiary.cgColor
        }
    }
}


