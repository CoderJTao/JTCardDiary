//
//  DiaryListCell.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/16.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

class DiaryListCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var shadowLayer: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.masksToBounds = false
        
        addShadow()
        
    }
    
    
    private func addShadow() {
        shadowLayer.layer.shadowColor = UIColor.gray.cgColor
        shadowLayer.layer.shadowOpacity = 0.6
        shadowLayer.layer.shadowRadius = 4.0
        shadowLayer.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.layer.shadowPath = UIBezierPath(rect: CGRect(x: -3, y: -3, width: kScreenWidth*0.75 + 6, height: (kScreenWidth*0.75-56) + 6)).cgPath
    
        //设置缓存
        shadowLayer.layer.shouldRasterize = true
    
        //设置抗锯齿边缘
        shadowLayer.layer.rasterizationScale = UIScreen.main.scale
    }

}
