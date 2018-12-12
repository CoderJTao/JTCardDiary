//
//  File.swift
//  JTDairy
//
//  Created by 江涛 on 2018/10/30.
//  Copyright © 2018 江涛. All rights reserved.
//

import Foundation
import UIKit

/*
 
 //无参无返回值
 typealias funcBlock = () -> () //或者 () -> Void
 //返回值是String
 typealias funcBlockA = (Int,Int) -> String
 //返回值是一个函数指针，入参为String
 typealias funcBlockB = (Int,Int) -> (String)->()
 //返回值是一个函数指针，入参为String 返回值也是String
 typealias funcBlockC = (Int,Int) -> (String)->String
 
 ----
 
 //block作为属性变量
 var blockProperty : (Int,Int) -> String = {a,b in return ""/**/} // 带初始化方式
 var blockPropertyNoReturn : (String) -> () = {param in }
 
 var blockPropertyA : funcBlockA?  //这写法就可以初始时为nil了,因为生命周其中，(理想状态)可能为nil所以用?
 var blockPropertyB : funcBlockB!  //这写法也可以初始时为nil了,因为生命周其中，(理想状态)认为不可能为nil,所以用!
 
 */


/// size
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

let kStatusBarHeight = UIApplication.shared.statusBarFrame.height

/// color
// 文字颜色
let TextColor_gray = "8E8E93"

let TextColor_black = "2D2D2D"

let TextColor_blue = "26BFFF"

let textColor_red = "FF5963"

// 分割线颜色
let SeparatColor = "EBEBEB"


// date
let MonthSubDic = ["1": "JAN", "2": "FEB", "3": "MAR", "4": "APR", "5": "MAY", "6": "JUN", "7": "JUL", "8": "AUG", "9": "SEP", "10": "OCT", "11": "NOV", "12": "DEC"]
let MonthDic = ["1": "JANUARY", "2": "FEBRUARY", "3": "MARCH", "4": "APRIL", "5": "MAY", "6": "JUNE", "7": "JULY", "8": "AUGUST", "9": "SEPTEMBER", "10": "OCTOBER", "11": "NOVEMBER", "12": "DECEMBER"]
let WeekDic = [1: "MON", 2: "TUE", 3: "WED", 4: "THU", 5: "FRI", 6: "SAT", 7: "SUN"]

// weather and mood
let WeatherDic = ["晴天": "qing_s", "阴天": "yintian_s", "刮风": "feng_s", "小雨": "xiaoyu_s", "大雨": "dayu_s", "阵雨": "zhenyu_s", "雪": "daxue_s", "雾": "wu_s"]
let MoodDic = ["开心": "happy_s", "无聊": "boring_s", "非常高兴": "lol_s", "酷炫": "cool_s", "疑问": "question_s", "难过": "sad_s", "悲伤": "cry_s", "愤怒": "shengqi_s"]


var CurrentDate: String {
    get {
        return Date().toString()  // yyyy-MM-dd
    }
}
var CurrentYear: String {
    get {
        return CurrentDate.components(separatedBy: "-").first!
    }
}
var CurrentMonth: String {
    get {
        return CurrentDate.components(separatedBy: "-")[1]
    }
}
var CurrentDay: String {
    get {
        return CurrentDate.components(separatedBy: "-").last!
    }
}


// some tool
func cutRounded(view: UIView) {
    let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: view.bounds.size)
    let maskLayer = CAShapeLayer()
    maskLayer.frame = view.bounds
    
    maskLayer.path = maskPath.cgPath
    view.layer.mask = maskLayer
}
