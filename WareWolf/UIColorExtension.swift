//
//  UIColor+Extension.swift
//  iPhoneOniGokko
//
//  Created by falcon@mac on H28/02/18.
//  Copyright (c) 平成28年 micom. All rights reserved.
//

import UIKit

extension UIColor {
    class func rgb(_ r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}
