//
//  JTCalendarView.swift
//  JTCalendar
//
//  Created by 江涛 on 2018/10/24.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

protocol JTCalendarViewDelegate: AnyObject {
    func currentDate(date: String)
}

class JTCalendarView: UIView {
    
    weak var delegate: JTCalendarViewDelegate?
    
    fileprivate var contentViewHeight: CGFloat {
        get {
            return self.frame.size.height
        }
    }
    
    fileprivate let reuseIdentifier: String = "JTCalendarCell"
    
    var date: Date!
    fileprivate var isCurrentMonth: Bool = false //是否当月
    fileprivate var currentMonthTotalDays: Int = 0 //当月的总天数
    fileprivate var firstDayIsWeekInMonth: Int = 0 //每月的一号对于的周几
    fileprivate var lastSelectedItemIndex: IndexPath? //获取最后一次选中的索引
    fileprivate var today: String {
        get {
            return String(JTDateUtils.day(Date()))
        }
    } //当天几号

    private var itemWidth: CGFloat {
        get {
            return (self.width - margin * 6) / 7.0
        }
    }
    private var itemHeight: CGFloat {
        get {
            return self.itemWidth
        }
    }
    
    private let margin: CGFloat = 2

    // 日历显示
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin

        let collectionV = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionV.isScrollEnabled = false
        collectionV.backgroundColor = UIColor.white
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.register(JTCalendarCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return collectionV
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        self.backgroundColor = UIColor.white
    }
    
    func setDate(dateStr: String) {
        let str = dateStr + "-15"
        let getDate = str.toDate()
        self.date = getDate
        self.initCurrentMonthInfo()
    }
    
    func setFrame(rect: CGRect) {
        self.frame = rect
        self.collectionView.frame = self.bounds
        self.collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    /// 获取日历视图需要的高度
//    class func getCalendarViewHeight(_ date: Date = Date()) -> CGFloat {
//        let total = JTDateUtils.daysInCurrMonth(date)  // 当月总天数
//        let first = JTDateUtils.firstDayIsWeekInMonth(date) //当月第一天是星期几
//
//        let days = total + first
//        let rowCount: CGFloat = CGFloat((days / 7) + 1)
//        let height = 44 * rowCount + margin * (rowCount-1) + 2 * margin
//        return height
//    }
    
    /// 初始化数据
    private func initCurrentMonthInfo() {
        //当前月份的总天数
        self.currentMonthTotalDays = JTDateUtils.daysInCurrMonth(date)
        
        //当前月份第一天是周几
        self.firstDayIsWeekInMonth = JTDateUtils.firstDayIsWeekInMonth(date)
        
        // 当天年月
        self.delegate?.currentDate(date: JTDateUtils.stringFromDate(date: date, format: "yyyy-MM"))
        
        //是否当月
        let nowDate: String = JTDateUtils.stringFromDate(date: Date(), format: "yyyy-MM")
        self.isCurrentMonth = nowDate == JTDateUtils.stringFromDate(date: date, format: "yyyy-MM")
        
        self.collectionView.reloadData()
    }
}


extension JTCalendarView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let days = self.currentMonthTotalDays + self.firstDayIsWeekInMonth
        return days
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! JTCalendarCell
        cell.clear()
        
        var day = 0
        let index = indexPath.row
        
        if index < self.firstDayIsWeekInMonth {
            //本月y1号之前的日子
            cell.daysLbl.text = ""
            cell.backgroundColor = UIColor.white
        } else {
            day = index - self.firstDayIsWeekInMonth + 1
            cell.daysLbl.text = String(day)
            
            if index % 7 == 0 {
                cell.dayType = .sunday
            } else if index % 7 == 6 {
                cell.dayType = .saturday
            } else {
                cell.dayType = .workday
            }
            
            if isCurrentMonth {
                // 当月 选重点当天
                if cell.daysLbl.text == today {
                    cell.isToDay = true
                } else {
                    cell.isToDay = false
                }
            } else {
                // 非当前月份默认选中1号
//                if cell.daysLbl.text == "1" {
//                    cell.daysLbl.textColor = UIColor.hexString(hexString: "IconColor")
//                } else {
//                    cell.daysLbl.textColor = UIColor.hexString(hexString: "TextColor")
//                }
            }
        }
        cell.isWrited = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
}
