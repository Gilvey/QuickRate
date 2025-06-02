//
//  TextField.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import UIKit

final class TextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    
    init(placeHolder: String, isEnable: Bool = true) {
        super.init(frame: .zero)
        self.placeholder = placeHolder
        self.isUserInteractionEnabled = isEnable
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    private func configure() {
        self.keyboardType = .decimalPad
        self.layer.cornerRadius = 14
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.AppColors.grayTertiary.cgColor
    }
}
