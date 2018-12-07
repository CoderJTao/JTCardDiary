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
    // singleton
    internal static let sharedInstance = {
        return DiaryManager()
    }()
    
    private init() {}

//    private var defaultDiaryModel: DiaryModel = DiaryModel()
//
    
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
    
    /// 首页
    // year: 2018
    /// 获取当年每个月的日记概况
    func getMonthsInfo(year: String) -> [MonthModel] {
        let arr: [MonthModel] = []
        
        return arr
    }
    
    /// 首页
    // date: 2018-12
    /// 获取当月每天的写作情况
    func getDaysInfo(date: String) -> [DayModel] {
        let arr: [DayModel] = []
        
        return arr
    }
    
    /// 列表展示页
    //  date: 2018-12
    /// 获取当月所有日记列表
    func getDiarys(date: String) -> [DiaryModel] {
        let arr: [DiaryModel] = []
        
        return arr
    }
    
    // date: 2018-12-7
    /// 增加一篇日记
    func addADiary(date: String) {
        
        
    }
    
    // date: 2018-12-7
    /// 删除一篇日记
    func deleteDiary(date: String) {
        
    }
    
    // date: 2018-12-7
    /// 更新一篇日记
    func updateDiary(date: String) {
        
        
    }
    
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



