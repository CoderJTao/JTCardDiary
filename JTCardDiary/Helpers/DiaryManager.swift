//
//  DiartManager.swift
//  JTDairy
//
//  Created by 江涛 on 2018/10/30.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
//import RealmSwift

class DiaryManager {
//    // singleton
//    internal static let sharedInstance = {
//        return DiaryManager()
//    }()
//
//    private var defaultDiaryModel: DiaryModel = DiaryModel()
//
//    private init() {
//
//    }
//
//    private func getRealm() -> Realm {
//        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
//        let dbPath = docPath.appending("/defaultDB.realm")
//        /// 传入路径会自动创建数据库
//        let defaultRealm = try! Realm(fileURL: URL.init(string: dbPath)!)
//        return defaultRealm
//    }
}

extension DiaryManager {
//    /// 获取指定日期日记
//    func getDiaryModel(date: String) -> DiaryModel {
//        let defaultRealm = self.getRealm()
//
//        var returnModel = DiaryModel()
//
//        let diaryModels = defaultRealm.objects(DiaryRealm.self).filter("date == %@", date)
//        if diaryModels.count > 0 {
//            //次日期存储了日记
//            let diary = diaryModels[0]
//
//            returnModel.date = diary.date
//            returnModel.week = diary.week
//            returnModel.mood = diary.mood
//            returnModel.weather = diary.weather
//
//            var gridArr: [GridModel] = []
//
//            for value in diary.grid_list {
//                var grid = GridModel()
//
//                grid.isEdited = value.isEdited
//                grid.sorted_num = value.sorted_num
//                grid.title = value.title
//                grid.content = value.content
//
//                var imageArr: [Data] = []
//                for use in value.images {
//                    imageArr.append(use)
//                }
//                grid.images = imageArr
//
//                gridArr.append(grid)
//            }
//
//            returnModel.grid_list = gridArr
//
//            return returnModel
//        }
//
//        // 返回默认日记模板
//        return DiaryModel.defaultDiaryModel(date: date)
//    }
}



