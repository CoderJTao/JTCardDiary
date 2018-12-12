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
    
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var weekLbl: UILabel!
    
    @IBOutlet weak var moodImg: UIImageView!
    @IBOutlet weak var weatherImg: UIImageView!
    
    @IBOutlet weak var coverImg: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    var _diary: DiaryInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.masksToBounds = false
        
        addShadow()
        
    }
    
    func setDiary(diary: DiaryInfo) {
        // need set
        self.dayLbl.text = diary.date?.getCurrentDay()
        self.weekLbl.text = diary.date?.getWeekDayString()
        if let use = diary.weather {
            self.weatherImg.image = UIImage(named: WeatherDic[use]!)
        }
        if let use = diary.mood {
            self.moodImg.image = UIImage(named: MoodDic[use]!)
        }
        
        self.moodImg.image = nil
        
        guard let cover = diary.images?.firstObject else {
            self.coverImg.isHidden = true
            self.titleLbl.isHidden = false
            self.contentLbl.isHidden = false
            //无封面
            
            self.titleLbl.text = diary.title
            self.contentLbl.text = diary.normalText
            
            return
        }
        
        // 有封面
        self.coverImg.isHidden = false
        self.titleLbl.isHidden = true
        self.contentLbl.isHidden = true
        
        let use = cover as! StoreImgInfo
        if let imgData = use.imgData {
            self.coverImg.image = UIImage(data: imgData)
        }
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
