//
//  FormatView.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/20.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

class FormatView: UIView {
    
    private let Font_Tag = 331
    
    var fontClick: ()->() = {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    @IBAction func fontClick(_ sender: UIButton) {
        
        self.fontClick()
    }
    
    
    
}
