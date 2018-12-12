//
//  ModelRealm.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/12/7.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import RealmSwift

/*
 var date: String
 var cover: String?
 var color: String   // 16进制
 var totalDays: Int
 var writed: Int = 0
 */
class MonthModelRealm: Object {
    @objc dynamic var date: String = ""
    
    @objc dynamic var cover: String?
    
    @objc dynamic var color: String = ""
    
    @objc dynamic var totalDays: Int = 0
    
    @objc dynamic var writed: Int = 0
    
    override static func indexedProperties() -> [String] {
        return ["date"]
    }
}


class DiaryModelRealm: Object {
    @objc dynamic var date: String = ""
    
    @objc dynamic var title: String = ""
    
    @objc dynamic var weather: String = "阴天"
    
    @objc dynamic var mood: String = "开心"
    
    @objc dynamic var richText: NSAttributedString = NSAttributedString(string: "")
    
    var images = List<StoreImgModelRealm>()
    
//    let owner = LinkingObjects(fromType: UserRealm.self, property: "devices")
    
    override static func indexedProperties() -> [String] {
        return ["title", "richText"]
    }
    
//    override static func primaryKey() -> String? {
//        return "deviceId"
//    }
}

class StoreImgModelRealm: Object {
    @objc dynamic var insetIndex: Int = 0
    
    @objc dynamic var imgData: Data?
    
}
