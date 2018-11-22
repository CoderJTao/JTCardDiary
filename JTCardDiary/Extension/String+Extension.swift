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
    
    /// 根据日期获取星期几
    func getWeekDayString() -> String {
        
        return ""
    }
    
}
