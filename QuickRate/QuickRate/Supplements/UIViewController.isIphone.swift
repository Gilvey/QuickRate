//
//  UIViewController.isIphone.swift
//  QuickRate
//
//  Created by Nikolay Gilvey on 2.06.25.
//

import UIKit

extension UIViewController {
    var isIphone: Bool {
        UIDevice.current.model == "iPhone"
    }
}
