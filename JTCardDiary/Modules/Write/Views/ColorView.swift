//
//  ColorView.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/23.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

class ColorView: UIView {
    
    private let Color_Tag = 10001
    
    private let colorArr: [String] = ["2D2D2D", "8E8E93", "26BFFF", "B1E2FF", "A7D7CB", "FCE85A", "82CAF2", "C9FF87", "6AECD2", "A1EOEF", "A1E0EF", "A1ECD0", "F9B674", "A6DFCC", "4D839B", "FABD6B", "E35A49", "3AADEF"]
    
    private let widthAndHeight: CGFloat = 36
    
    private var margin: CGFloat {
        get {
            return (kScreenWidth - (6.0 * widthAndHeight)) / 7
        }
    }
    
    var colorClick: (String) -> () = { (_) in
        
    }
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: self.bounds)
        scroll.showsVerticalScrollIndicator = true
        scroll.bounces = true
        return scroll
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(colorStr: String) {
        let index = self.colorArr.index(of:colorStr)
        
    }
    
    
    private func setUpUI() {
        for (index, value) in colorArr.enumerated() {
            let lbl = UILabel(frame: CGRect(x: margin+(margin+widthAndHeight)*CGFloat(index%6), y: margin+(margin+widthAndHeight)*CGFloat(index/6), width: widthAndHeight, height: widthAndHeight))
            
            lbl.tag = index + Color_Tag
            lbl.backgroundColor = UIColor.hexString(hexString: value)
            lbl.cutCornerRadius(position: UIRectCorner.allCorners, radius: widthAndHeight / 2.0)
            
            lbl.isUserInteractionEnabled = true
            lbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colorPicker(_:))))
            
            scrollView.addSubview(lbl)
        }
        
        let a: CGFloat = CGFloat(colorArr.count / 6)
        let b: CGFloat = CGFloat(colorArr.count % 6)
        
        if a == 0 && b == 0 {
            return
        } else if a == 0 && b > 0 {
            scrollView.contentSize = CGSize(width: kScreenWidth, height: (a+1) * (margin+widthAndHeight) + margin)
        } else if a > 0 && b > 0 {
            scrollView.contentSize = CGSize(width: kScreenWidth, height: (a+1) * (margin+widthAndHeight) + margin)
        } else if a > 0 && b == 0 {
            scrollView.contentSize = CGSize(width: kScreenWidth, height: a * (margin+widthAndHeight) + margin)
        }
        scrollView.frame = self.bounds
        self.addSubview(scrollView)
    }
    
    @objc private func colorPicker(_ sender: UITapGestureRecognizer) {
        let view = sender.view as! UILabel
        
        self.colorClick(colorArr[view.tag - Color_Tag])
    }
    
}
