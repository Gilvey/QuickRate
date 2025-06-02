//
//  ImageManager.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import UIKit

extension UIImage {
    enum SystemIcon: String {
        case arrowUpArrowDown = "arrow.up.arrow.down"
        case loader = "arrow.trianglehead.2.clockwise.rotate.90"
    }
    
    convenience init?(_ icon: SystemIcon) {
        self.init(systemName: icon.rawValue)
    }
}
