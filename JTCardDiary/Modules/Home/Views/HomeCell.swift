//
//  HomeCell.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/13.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    @IBOutlet weak var showImg: UIImageView!
    
    @IBOutlet weak var normalView: UIView!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var monthEnLbl: UILabel!
    @IBOutlet weak var pageIndexLbl: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var progressBackGroundLbl: UILabel!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var constraintProgressWidth: NSLayoutConstraint!
    
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var calMonthLbl: UILabel!
    @IBOutlet weak var calMonthEnLbl: UILabel!
    @IBOutlet weak var calendarContentView: UIView!
    
    private lazy var calendar: JTCalendarView = {
        let view = JTCalendarView(frame: self.calendarContentView.bounds)
        return view
    }()
    
    var cellBgClick: (HomeCell) -> () = {_ in 
        
    }
    
    var monthModel: MonthInfo?
    
    var isCalendar: Bool = false
    {
        didSet {
            if isCalendar {
                self.calendarView.isHidden = false
                self.normalView.isHidden = true
            } else {
                self.calendarView.isHidden = true
                self.normalView.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.calendarContentView.addSubview(self.calendar)
        self.calendarView.isHidden = true
        self.normalView.isHidden = false
        
        self.layer.masksToBounds = false
        
        self.showImg.isHidden = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.calendar.setFrame(rect: self.calendarContentView.bounds)
    }
    

    @IBAction func moreBtnClick(_ sender: UIButton) {
        self.cellBgClick(self)
    }
    
    func setMonthModel(model: MonthInfo) {
        self.monthModel = model
        
        if let use = model.date {
            self.calendar.setDate(dateStr: use)
            
            let arr = use.components(separatedBy: "-")
            let month = arr.last!
            
            self.monthLbl.text = month
            self.monthEnLbl.text = MonthSubDic[month]
            
            self.calMonthLbl.text = month
            self.calMonthEnLbl.text = MonthSubDic[month]
        }
        
        if let use = model.cover {
            self.showImg.image = UIImage(data: use)
            self.showImg.isHidden = false
        } else {
            self.showImg.isHidden = true
            if let use = model.color {
                self.normalView.backgroundColor = UIColor.hexString(hexString: use)
            }
        }
        
        self.pageIndexLbl.text = "\(model.writed)" + "/" + "\(model.totalDays)"
        
        let progress = CGFloat(model.writed) / CGFloat(model.totalDays)
        self.constraintProgressWidth.constant = self.progressBackGroundLbl.width * progress
    }
}
