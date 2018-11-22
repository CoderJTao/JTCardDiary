//
//  MonthModel.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/14.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import Foundation

//protocol BaseJsonModel{
//    init(json: [String: Any]) throws
//}

struct MonthModel {
    var date: String
    var cover: String?
    var color: String   // 16进制
    var totalDays: Int
    var isWrited: Int
}



