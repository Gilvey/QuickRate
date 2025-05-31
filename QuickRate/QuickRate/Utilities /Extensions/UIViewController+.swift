//
//  UIViewController+.swift
//  QuickRate
//
//  Created by Nikolay Gilvey on 31.05.25.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    func startRotating(for view: UIView) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.isRemovedOnCompletion = false
        view.layer.add(animation, forKey: "rotation")
    }
    
    func stopRotation(for view: UIView) {
        view.layer.removeAllAnimations()
    }
}
