//
//  MonthModel.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/14.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import Foundation

struct MonthModel {
    var date: String = ""
    var cover: String?
    var color: String   // 16进制
    var totalDays: Int?
    var writed: Int = 0
}

struct DayModel {
    var dateIndex: Int
    
    var isWrited: Bool = false
}

struct DiaryModel {
    var date: String?
    
    var title: String = ""
    var weather: String = "阴天"
    var mood: String = "开心"
        
    var richText: NSAttributedString = NSAttributedString(string: "")
    var normalText: String = ""
    
    var images: [StoreImgModel] = []
    
    func isEqual(model: DiaryModel) -> Bool {
        if title == model.title && weather == model.weather && mood == model.mood && richText.isEqual(to: model.richText) && images.count == model.images.count {
            for index in 0..<images.count {
                if !images[index].isEqual(model: model.images[index]) {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func richToData() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: richText.transformToArray(), requiringSecureCoding: true)
    }
}

struct StoreImgModel {
    var insetIndex: Int = 0
    
    var imgData: Data?
    
    func isEqual(model: StoreImgModel) -> Bool {
        if insetIndex == model.insetIndex && imgData == model.imgData {
            return true
        }
        return false
    }
}



