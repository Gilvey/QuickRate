//
//  Button.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import UIKit

final class Button: UIButton {
    
    enum Style {
        case currencyButton
        case switchButton
    }
    
    private let style: Style
    
    init(style: Style, image: UIImage? = nil) {
        self.style = style
        super.init(frame: .zero)
        if let image = image {
            self.setImage(image, for: .normal)
        }
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 8
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        tintColor = .AppColors.neutralBlack
        
        switch style {
        case .currencyButton:
            backgroundColor = .AppColors.blue
            setTitleColor(.AppColors.neutralWhite, for: .normal)
        case .switchButton:
            backgroundColor = .AppColors.neutralWhite
            tintColor = .AppColors.blue
            layer.borderWidth = 1
            layer.borderColor = UIColor.AppColors.grayTertiary.cgColor
        }
    }
}


