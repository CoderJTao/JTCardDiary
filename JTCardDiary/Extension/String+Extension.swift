//
//  String+Extension.swift
//  JTDairy
//
//  Created by 江涛 on 2018/10/31.
//  Copyright © 2018 江涛. All rights reserved.
//

import Foundation

extension String {
    
    /// 根据字符串获取日期
    func toDate(_ format: String = "yyyy-MM-dd") -> Date {
        let formatter = DateFormatter.init()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = format
        
        return formatter.date(from: self) ?? Date()
    }
    
    /// 根据日期得到当前年份
    // (yyyy-MM-dd hh:mm:ss)
    func getYear() -> String {
        let arr = self.components(separatedBy: "-")
        
        return arr.first ?? CurrentYear
    }
    
    /// 根据日期得到当前dd
    // (yyyy-MM-dd hh:mm:ss)   (yyyy-MM-dd)
    func getCurrentDay() -> String {
        let arr = self.components(separatedBy: " ")  // yyyy-MM-dd
        
        let results = arr.first?.components(separatedBy: "-")
        
        return results?.last ?? ""
    }
    
    /// 根据日期获取星期几
    func getWeekDayString() -> String {
        var calender = Calendar.current
        calender.firstWeekday = 1
        var com = (calender as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: self.toDate())
        let firstDay = calender.date(from: com)
        let firstWeek = (calender as NSCalendar).ordinality(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.weekOfMonth, for: firstDay!)
        return WeekDic[firstWeek - 1] ?? ""
    }
    
}
