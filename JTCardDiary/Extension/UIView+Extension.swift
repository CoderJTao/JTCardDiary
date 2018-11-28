//
//  UIView+Extension.swift
//  JTDairy
//
//  Created by 江涛 on 2018/10/25.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

extension UIView {
    
    /// originX
    var originX: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    /// originY
    var originY: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    /// width
    var width: CGFloat {
        get {
            return frame.size.width
        }
        
        set {
            frame.size.width = newValue
        }
    }
    
    /// height
    var height: CGFloat {
        get {
            return frame.size.height
        }
        
        set {
            frame.size.height = newValue
        }
    }
    
    /// size
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }
    
    /// centerX
    var centerX: CGFloat {
        get {
            return center.x
        }
        
        set {
            center.x = newValue
        }
    }
    
    /// centerY
    var centerY: CGFloat {
        get {
            return center.y
        }
        
        set {
            center.y = newValue
        }
    }
    
    /// bottomY
    var bottomY: CGFloat {
        get {
            return originY+height
        }
    }
    var rightX: CGFloat {
        get {
            return originX+width
        }
    }
    
    /// 切圆角
    func cutCornerRadius(position: UIRectCorner, radius: CGFloat) {
        //创建贝塞尔,指定画圆角的地方为下方的左，右两个角添加阴影
        let mask:UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: position, cornerRadii: CGSize(width: radius, height: radius))
        let shape:CAShapeLayer = CAShapeLayer()
        shape.fillColor = self.backgroundColor!.cgColor
        //Layer的线为贝塞尔曲线
        
        shape.path = mask.cgPath
        shape.frame = self.bounds
        
        self.layer.mask = shape
        self.layer.masksToBounds = true
    }
    
    /// 为view添加线条
    func addLine(_ color: CGColor = UIColor(r: 230, g: 230, b: 230).cgColor, positon: LinePosition) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color
        
        var frame = CGRect.zero
        switch positon {
        case .left:
            frame = CGRect(x:0, y:0, width:width, height:self.height)
        case .right:
            frame = CGRect(x:self.width - width, y:0, width:width, height:self.height)
        case .top:
            frame = CGRect(x:0, y:0, width:self.width, height:width)
        case .bottom:
            frame = CGRect(x:0, y:self.height - width, width:self.width, height:1)
        }
        
        border.frame = CGRect(x:0, y:self.height - width, width:self.width, height:1)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

enum LinePosition {
    case left
    case right
    case top
    case bottom
}
