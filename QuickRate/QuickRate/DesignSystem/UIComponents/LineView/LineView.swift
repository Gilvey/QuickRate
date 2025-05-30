//
//  LineView.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import UIKit

final class LineView: UIView {
    
    private let lineHeight: CGFloat = 1
    
    init(color: UIColor) {
        super.init(frame: .zero)
        self.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: lineHeight)
    }
}
