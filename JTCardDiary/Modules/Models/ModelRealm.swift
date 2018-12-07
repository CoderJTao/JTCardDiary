//
//  ModelRealm.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/12/7.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import RealmSwift

class DiaryModelRealm: Object {
//    var title: String?
//    var weather: String = "阴天"
//    var mood: String = "开心"
//
//    var richText: NSAttributedString = NSAttributedString(string: "")
//
//    var images: [StoreImgModel] = []
    
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
