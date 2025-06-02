//
//  TextField+.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap {
                ($0.object as? UITextField)?.text
            }
            .eraseToAnyPublisher()
    }
}
