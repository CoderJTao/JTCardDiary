//
//  RichtextTransformer.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/12/12.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

class RichtextTransformer: ValueTransformer {
    /**     允许转换    */
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
     /**     转换成什么类    */
    override class func transformedValueClass() -> AnyClass {
        return NSAttributedString.self
    }
    
    /**     返回转换后的对象    */
    override func transformedValue(_ value: Any?) -> Any? {
        // 将 NSAttributedString 转化为Data
        let atb = value as! NSAttributedString
        
        return try? NSKeyedArchiver.archivedData(withRootObject: atb, requiringSecureCoding: true)
    }
    
    /**     重新生成原对象    */
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        let useData = value as! Data
        
        return try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSAttributedString.self], from: useData)
    }
}
