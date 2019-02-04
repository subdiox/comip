//
//  Extensions.swift
//  comicatalog
//
//  Created by subdiox on 2019/01/12.
//  Copyright © 2019 Yuta Ooka. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    static var main: UIColor {
        return UIColor(hex: 0xe2f1a8)
    }
    
    static var originalGreen: UIColor {
        return UIColor(hex: 0x589a3a)
    }
    
    static var originalOrange: UIColor {
        return UIColor(hex: 0xeeae3c)
    }
}

extension CALayer {
    @objc dynamic var borderUIColor: UIColor {
        get {
            return UIColor(cgColor: self.borderColor!)
        } set {
            self.borderColor = newValue.cgColor
        }
    }
}
