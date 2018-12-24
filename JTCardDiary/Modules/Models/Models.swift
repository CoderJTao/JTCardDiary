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

struct DiaryModel {
    var date: String?
    
    var title: String = ""
    var weather: String = "阴天"
    var mood: String = "开心"
        
    var richText: NSAttributedString = NSAttributedString(string: "")
    
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
    
    /*
     self.date = info.date
     self.title = info.title ?? ""
     self.weather = info.weather ?? "阴天"
     self.mood = info.mood ?? "开心"
     self.richText = info.richText ?? NSAttributedString(string: "")
     
     self.images = info.images?.array as? [StoreImgModel] ?? []
     */
    
    func transformToCDInfo() -> DiaryInfo {
        let diary = DiaryInfo(context: DiaryManager.sharedInstance.context)
        
        diary.date = self.date
        diary.title = self.title
        diary.weather = self.weather
        diary.mood = self.mood
        diary.richText = self.richText
        
        let sets = NSMutableOrderedSet()
        for value in images {
            let storeImgInfo = value.transformToCDInfo()
            sets.add(storeImgInfo)
        }
        diary.images = sets
        
        return diary
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
    
    func transformToCDInfo() -> StoreImgInfo {
        let storeImg = StoreImgInfo(context: DiaryManager.sharedInstance.context)
        storeImg.insertIndex = Int32(self.insetIndex)
        storeImg.imgData = self.imgData
        return storeImg
    }
}



