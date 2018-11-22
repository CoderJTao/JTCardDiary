//
//  JTDateUtils.swift
//  JTCalendar
//
//  Created by 江涛 on 2018/10/24.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit


class JTDateUtils: NSObject {
    /// Date转换String
    ///
    /// - Parameters:
    ///   - date: 日期
    ///   - format: 格式
    /// - Returns: 字符串日期
    class func stringFromDate(date: Date, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter.init()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = format
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    /// 获取今年所有月份数组
    class func getMonths(_ date: Date) -> [String] {
        var arr: [String] = []

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let yearStr = formatter.string(from: date)
        
        for index in 1...12 {
            arr.append(yearStr + "-" + "\(index)")
        }
        
        return arr
    }
    
    /// 获取今年所有月份天数数组
    class func getMonthDays(_ date: Date) -> [Int] {
        var arr: [Int] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let yearStr = formatter.string(from: date)
        
        for index in 1...12 {
            let str = yearStr + "-" + "\(index)"
            let new = str.toDate("yyyy-MM")
            
            let days = JTDateUtils.daysInCurrMonth(new)
            
            arr.append(days)
        }
        
        return arr
    }
    
    
    /// 上个月
    ///
    /// - Parameter date: 当前日期
    /// - Returns: 上月日期
    class func lastMonth(_ date: Date) -> Date {
        var dateCom = DateComponents()
        dateCom.month = -1
        let newDate = (Calendar.current as NSCalendar).date(byAdding: dateCom, to: date, options: NSCalendar.Options.matchStrictly)
        return newDate!
    }
    
    /// 下个月
    ///
    /// - Parameter date: 当前日期
    /// - Returns: 下个月日期
    class func nextMonth(_ date: Date) -> Date {
        var dateCom = DateComponents()
        let abc = 1
        dateCom.month = +abc
        let newDate = (Calendar.current as NSCalendar).date(byAdding: dateCom, to: date, options: NSCalendar.Options.matchStrictly)
        return newDate!
    }
    
    /// 当月的天数
    ///
    /// - Parameter date: 日期
    /// - Returns: 天数
    class func daysInCurrMonth(_ date: Date) -> Int {
        let days: NSRange = (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date)
        return days.length
    }
    
    /// 当前月份的第一天是周几
    ///
    /// - Parameter date: 当前日期
    /// - Returns: 周几
    class func firstDayIsWeekInMonth(_ date: Date) -> Int {
        var calender = Calendar.current
        calender.firstWeekday = 1
        var com = (calender as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date)
        com.day = 1
        let firstDay = calender.date(from: com)
        let firstWeek = (calender as NSCalendar).ordinality(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.weekOfMonth, for: firstDay!)
        return firstWeek - 1
    }
    
    /// 当前月份的几号
    ///
    /// - Parameter date: 当前月份
    /// - Returns: 几号
    class func day(_ date: Date) -> Int {
        let com = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date)
        return com.day!
    }
}
