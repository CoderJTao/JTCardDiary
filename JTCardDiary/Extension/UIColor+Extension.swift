//
//  UIColor+Extension.swift
//  JTDairy
//
//  Created by 江涛 on 2018/10/25.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    
    convenience init(r: UInt32, g: UInt32, b: UInt32, a: CGFloat = 1.0) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
    }
    
    /// 十六进制颜色码转换UIColor
    ///
    /// - Parameters:
    ///   - hex: 十六进制颜色码
    ///   - aplha: 透明度
    /// - Returns: UIColor
    class func hexString(hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cString.count < 6 { return UIColor.black }
        
        let index = cString.index(cString.endIndex, offsetBy: -6)
        let subString = cString[index...]
        
        if cString.hasPrefix("0X") {
            cString = String(subString)
        }
        if cString.hasPrefix("#") {
            cString = String(subString)
        }
        
        if cString.count != 6 {
            return UIColor.black
        }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(r: r, g: g, b: b, a: alpha)
    }
    
    /// 颜色码转换十六进制
    ///
    /// - Parameters:
    ///   - hex: 十六进制颜色码
    ///   - aplha: 透明度
    /// - Returns: 十六进制
    func toHexString() -> String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return String(format: "#%02x%02x%02x", Int(r * 255), Int(g * 255), Int(b * 255))
        }
        return ""
    }
    
}
