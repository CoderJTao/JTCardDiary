//
//  FormatView.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/20.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

class FormatView: UIView {
    
    var lastType: JTFontFormat = .none
    
    private let Font_Tag = 331
    
    var fontClick: (JTFontFormat, Bool)->() = { _, _ in
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// 对齐方式点击
    @IBAction func alignClick(_ sender: UIButton) {
        let typeNum = sender.tag - Font_Tag
        
        // 对齐
        for index in 331...333 {
            let btn = self.viewWithTag(index) as! UIButton
            btn.isSelected = false
        }
        sender.isSelected = true
        
        let type = JTFontFormat(rawValue: typeNum)!
        
        self.fontClick(type, true)
    }
    
    /// 分割线点击
    @IBAction func addLineClick(_ sender: UIButton) {
        let type = JTFontFormat.divider
        
        self.fontClick(type, true)
    }
    
    /// 粗体 斜体 下划线 贯穿线 点击
    @IBAction func fontClick(_ sender: UIButton) {
        let typeNum = sender.tag - Font_Tag
        
        let type = JTFontFormat(rawValue: typeNum)!
        
        // 粗体 斜体 下划线 贯穿线
        sender.isSelected = !sender.isSelected
        
        self.fontClick(type, sender.isSelected)
    }
    
    // 列表点击
    @IBAction func listClick(_ sender: UIButton) {
        
        var type: JTFontFormat
        var isChoose: Bool
        
        if sender.tag == 339 {
            // 有序列表
            if self.lastType == .listOL {
                sender.isSelected = false
                
                type = .none
                isChoose = false
            } else {
                sender.isSelected = true
                let btn = self.viewWithTag(340) as! UIButton
                btn.isSelected = false
                
                type = .listOL
                isChoose = true
            }
        } else {
            // 无序列表
            if self.lastType == .listUL {
                sender.isSelected = false
                
                type = .none
                isChoose = false
            } else {
                sender.isSelected = true
                let btn = self.viewWithTag(339) as! UIButton
                btn.isSelected = false
                
                type = .listUL
                isChoose = true
            }
        }
        
        self.lastType = type
        
        self.fontClick(type, isChoose)
    }
}

enum JTFontFormat: Int {
    case none = -1
    
    case alignLeft = 0
    case alignCenter = 1
    case alignRight = 2
    
    case divider = 3
    
    case beBold = 4
    case beItalic = 5
    
    case underLine = 6
    case throughLine = 7
    
    case listOL = 8  // 有序列表
    case listUL = 9  // 无序列表
}
