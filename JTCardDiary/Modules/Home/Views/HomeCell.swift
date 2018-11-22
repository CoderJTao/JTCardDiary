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
    
    var monthModel: MonthModel?
    
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
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.calendar.setFrame(rect: self.calendarContentView.bounds)
    }
    

    @IBAction func moreBtnClick(_ sender: UIButton) {
    }
    
    func setMonthModel(model: MonthModel) {
        self.monthModel = model
        
        self.calendar.setDate(dateStr: model.date)
        
        let arr = model.date.components(separatedBy: "-")
        let month = arr.last!
        
        self.monthLbl.text = month
        self.monthEnLbl.text = MonthSubDic[month]
        
        self.calMonthLbl.text = month
        self.calMonthEnLbl.text = MonthSubDic[month]
        
        self.normalView.backgroundColor = UIColor.hexString(hexString: model.color)
        
        self.pageIndexLbl.text = "\(model.isWrited)" + "/" + "\(model.totalDays)"
        
        let progress = CGFloat(model.isWrited) / CGFloat(model.totalDays)
        self.constraintProgressWidth.constant = self.progressBackGroundLbl.width * progress
    }
}
