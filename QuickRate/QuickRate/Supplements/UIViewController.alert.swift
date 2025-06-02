//
//  UIViewController.alert.swift
//  QuickRate
//
//  Created by Nikolay Gilvey on 2.06.25.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
