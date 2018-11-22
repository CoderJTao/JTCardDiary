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
}
