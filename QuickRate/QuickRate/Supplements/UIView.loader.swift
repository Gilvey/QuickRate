//
//  UIViewController+.swift
//  QuickRate
//
//  Created by Nikolay Gilvey on 31.05.25.
//

import UIKit

extension UIView {
    func startRotating() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "rotation")
    }
    
    func stopRotation() {
        layer.removeAllAnimations()
    }
}
