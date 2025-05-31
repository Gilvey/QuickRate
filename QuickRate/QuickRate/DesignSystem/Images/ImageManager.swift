//
//  ImageManager.swift
//  QuickRate
//
//  Created by Gilvey Nikolay on 30.05.25.
//

import UIKit

enum ImageManager {
    static var arrowUpArrowDown: UIImage {
        UIImage(systemName: "arrow.up.arrow.down") ?? UIImage()
    }
    
    static var loader: UIImage {
        UIImage(systemName: "arrow.trianglehead.2.clockwise.rotate.90") ?? UIImage()
    }
}
