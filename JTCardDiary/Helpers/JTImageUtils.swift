//
//  JTImageUtils.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/12/6.
//  Copyright © 2018 江涛. All rights reserved.
//

import Foundation
import UIKit

class JTImageUtils: NSObject {
    
    private static let CommonWidth: CGFloat = 40
    private static let CommonHeight: CGFloat = 20
    
    private static let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                                     NSAttributedString.Key.foregroundColor: UIColor.hexString(hexString: TextColor_black)]
    
    class func getImage(str: String) -> UIImage {
        let useStr: NSString = NSString(string: str + ".")
        
        let size = CGSize(width: CommonWidth, height: CommonHeight)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let colorImg = UIColor.hexString(hexString: "000000", alpha: 0).image()
        
        colorImg.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        useStr.draw(in: CGRect(x: 20, y: 0, width: 10, height: 20), withAttributes: attributes)
        
        let context = UIGraphicsGetCurrentContext()
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func getDotImage() -> UIImage {
        let image = UIImage(named: "dot")!
        
        let size = CGSize(width: CommonWidth, height: CommonHeight)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let colorImg = UIColor.hexString(hexString: "000000", alpha: 0).image()
        
        colorImg.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        image.draw(in: CGRect(x: 20, y: 6, width: 8, height: 8))
        
        let context = UIGraphicsGetCurrentContext()
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
