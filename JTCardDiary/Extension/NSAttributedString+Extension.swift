//
//  NSAttributedString+Extension.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/28.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import Foundation

extension NSAttributedString {
    
    /// get should config paragraph range
    ///
    /// - Parameter selectRange: cursor position
    /// - Returns: paragraph range
    func getParagraphRange(selectRange: NSRange) -> NSRange {
        
        let tempStr = NSString(string: self.string)
        
        var beforeRange = tempStr.range(of: "\n", options: NSString.CompareOptions.backwards, range: NSRange(location: 0, length: selectRange.location))
        
        if beforeRange.location == NSNotFound {
            beforeRange.location = 0
        }
        
        var afetrRange = tempStr.range(of: "\n", options: NSString.CompareOptions.forcedOrdering, range: NSRange(location: selectRange.location, length: tempStr.length - selectRange.location))
        
        if afetrRange.location == NSNotFound {
            afetrRange.location = tempStr.length
        }
        
        let length = (afetrRange.location - beforeRange.location + 1) > selectRange.location ? selectRange.location : (afetrRange.location - beforeRange.location + 1)
        
        return NSRange(location: beforeRange.location + beforeRange.length, length: length)
    }
    
    func transformToArray() -> [[String: Any]] {
        var result: [[String: Any]] = []
        
        self.enumerateAttributes(in: NSRange(location: 0, length: self.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (attributeDic, range, stop) in
            
            var dict: [String: Any] = [:]
            
            //1.  通过range取出相应的字符串
            let useStr = NSString(string: self.string)
            let title = useStr.substring(with: range)
            
            //1.把属性字典和相应字符串成为一个大字典
            dict["content"] = title
            
            // 2. NSFont
            let font = attributeDic[NSAttributedString.Key.font] as? UIFont
            if let use = font {
                let size = use.fontDescriptor.pointSize
                dict["font"] = NSNumber(value: Float(size))
            }
            
            //3.取出字体描述fontDescriptor
            let bold = attributeDic[NSAttributedString.Key.strokeWidth] as? Int
            
            if let use = bold {
                if use < 0 {
                    dict["bold"] = NSNumber(value: true)
                } else {
                    dict["bold"] = NSNumber(value: false)
                }
            }
   
            let obliq = attributeDic[NSAttributedString.Key.obliqueness] as? CGFloat
            
            if let use = obliq {
                if use > 0 {
                    dict["obliq"] = NSNumber(value: true)
                } else {
                    dict["obliq"] = NSNumber(value: false)
                }
            }
            
            let underLine = attributeDic[NSAttributedString.Key.underlineStyle] as? Int
            
            if let use = underLine {
                if use > 0 {
                    dict["underLine"] = NSNumber(value: true)
                } else {
                    dict["underLine"] = NSNumber(value: false)
                }
            }
            
            let strikethrough = attributeDic[NSAttributedString.Key.strikethroughStyle] as? Int
            
            if let use = strikethrough {
                if use > 0 {
                    dict["strikethrough"] = NSNumber(value: true)
                } else {
                    dict["strikethrough"] = NSNumber(value: false)
                }
            }
            
            //4.字体－颜色
            let fontColor = attributeDic[NSAttributedString.Key.foregroundColor] as? UIColor
            
            if let use = fontColor {
                dict["color"] = use.toHexString()
            }
            
            //5.行间距
//            let paragraphStyle = attributeDic[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle
//
//            if let use = paragraphStyle {
//                dict["lineSpace"] = NSNumber(value: Float(use.lineSpacing))
//            }

            //7.返回一个数组
            result.append(dict)
        }
        
        return result
    }
}
