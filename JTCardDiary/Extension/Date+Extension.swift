//
//  Date+Extension.swift
//  JTDairy
//
//  Created by 江涛 on 2018/10/30.
//  Copyright © 2018 江涛. All rights reserved.
//

import Foundation

extension Date {
    
//    static func parseISO8601(string: String) -> Date? {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
//        return formatter.date(from: string)
//    }
    
    /// 根据日期获取日期字符串
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    
    /// 根据日期获取当前月份
    
}
