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
            
            //5.图片
            let imageAtt = attributeDic[NSAttributedString.Key.attachment] as? NSTextAttachment
            
            if let use = imageAtt {
                if let image = use.image {
                    let data = image.pngData()
                    if let useData = data {
                        let encodedImageStr = useData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
                        dict["image"] = encodedImageStr
                    }
                }
                
                
            }
            
            //6.行间距
            let paragraphStyle = attributeDic[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle
            
            if let use = paragraphStyle {
                dict["lineSpace"] = NSNumber(value: Float(use.lineSpacing))
            }

            //7.返回一个数组
            result.append(dict)
        }
        
        return result
    }
}
