//
//  DiartManager.swift
//  JTDairy
//
//  Created by 江涛 on 2018/10/30.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import CoreData

class DiaryManager {
    // 单例
    static let sharedInstance = DiaryManager()
    
    // 拿到AppDelegate中创建好了的NSManagedObjectContext
    lazy var context: NSManagedObjectContext = {
        let context = ((UIApplication.shared.delegate) as! AppDelegate).context
        return context
    }()
    
    // 更新数据
    private func saveContext() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
   
}

extension DiaryManager {
    /// 初始化之后，先将当前年份信息存下
    func saveYearInfo(year: String) {
        let createYearInfo = {
            let yearInfo = YearInfo(context: self.context)
            
            yearInfo.date = year
            
            let daysArr = JTDateUtils.getMonthDays(Date())
            
            var temp: [MonthInfo] = []
            for index in 0..<12 {
                let month = MonthInfo(context: self.context)
                
                month.date = year + "-\(index+1)"
                month.color = "26BFFF"
                month.cover = nil
                month.totalDays = Int64(daysArr[index])
                month.writed = 0
                
                temp.append(month)
            }
            
            yearInfo.months = NSOrderedSet(array: temp)
            
            do {
                try self.context.save()
            } catch let error as NSError {
                debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
            }
        }
        
        
        let yearFetch: NSFetchRequest<YearInfo> = YearInfo.fetchRequest()
        yearFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(YearInfo.date), year)
        
        do {
            let years = try self.context.fetch(yearFetch)
            if years.count == 0 {
                // 生成当前年份的月份信息
                createYearInfo()
            } else {
                // 更新当前年份的月份信息
            }
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
        }
    }
    
    
    /// 获取当年每个月的概况 [MonthModels]
    func getCurrentYearMonths(year: String) -> [MonthInfo] {
        var result: [MonthInfo] = []
        
        let yearFetch: NSFetchRequest<YearInfo> = YearInfo.fetchRequest()
        yearFetch.predicate = NSPredicate(format: "date == %@", year)
        
        do {
            let allYears = try context.fetch(yearFetch)
            
            let resultYear = allYears.filter {
                $0.date == year
            }
            
            if resultYear.count == 0 {
                self.saveYearInfo(year: year)
                return getCurrentYearMonths(year: year)
            } else {
                if let tempYear = resultYear.first {
                    if let months = tempYear.months {
                        for value in months {
                            if let model = value as? MonthInfo {
                                result.append(model)
                            }
                        }
                    }
                }
            }
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
        }
        
        return result
    }
    
    /// 更新当前月份的信息
    func updateMonthInfo(info: MonthInfo) {
        guard let currentDate = info.date else {
            return
        }
        
        let fetchRequest: NSFetchRequest<MonthInfo> = MonthInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", currentDate)
        
        do {
            let result = try self.context.fetch(fetchRequest)
            
            for value in result {
                value.date = info.date
                value.color = info.color
                value.cover = info.cover
                value.totalDays = info.totalDays
                value.writed = info.writed
                value.diarys = info.diarys
            }
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
        }
        
        saveContext()
    }
    
    /// 获取当前月份所有日记列表
    func getDiarysOfMonth(month: String) -> [DiaryInfo] {
        let fetchRequest: NSFetchRequest<MonthInfo> = MonthInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", month)
        
        var returnArr: [DiaryInfo] = []
        
        do {
            let result = try self.context.fetch(fetchRequest).first
            
            
            if let diarys = result?.diarys {
                for value in diarys {
                    let use = value as! DiaryInfo
                    returnArr.append(use)
                }
                
                return returnArr
            }
            
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
        }
        
        return returnArr
    }
    
    /// 增加一篇日记
    func addANewDiary(info: DiaryInfo) {
        guard let diaryDate = info.date else {
            return
        }
        
        let monthDate = diaryDate.getMonthDate()
        
        let fetchRequest: NSFetchRequest<MonthInfo> = MonthInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", monthDate)
        
        do {
            let result = try self.context.fetch(fetchRequest).first
            
            if result?.diarys != nil {
                let set = NSMutableOrderedSet(orderedSet: (result?.diarys)!)
                set.add(info)
                result?.diarys = set
                result?.writed = Int64(set.count)
            } else {
                let set = NSOrderedSet(object: info)
                result?.diarys = set
                result?.writed = Int64(set.count)
            }
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
        }
        
        saveContext()
    }
    
    /// 删除一篇日记
    func deleteADiary(info: DiaryInfo) {
        guard let diaryDate = info.date else {
            return
        }
        
        let monthDate = diaryDate.getMonthDate()
        
        let fetchRequest: NSFetchRequest<MonthInfo> = MonthInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", monthDate)
        
        do {
            let result = try self.context.fetch(fetchRequest).first
            
            var tempDiarys = NSOrderedSet()
            if let diarys = result?.diarys {
                let lastArr = diarys.filter { (value) -> Bool in
                    let use = value as! DiaryInfo
                    return use.date != info.date
                }
                
                tempDiarys = NSOrderedSet(array: lastArr)
            }
            
            result?.diarys = tempDiarys
            result?.writed = Int64(tempDiarys.count)
            
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
        }
        
        saveContext()
    }
    
    /// 更新一篇日记
    func updateADiary(original: DiaryInfo, newModel: DiaryInfo) {
        guard let diaryDate = original.date else {
            return
        }
        
        let monthDate = diaryDate.getMonthDate()
        
        let fetchRequest: NSFetchRequest<MonthInfo> = MonthInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", monthDate)
        
        do {
            let result = try self.context.fetch(fetchRequest).first
            
            var tempDiarys = NSMutableOrderedSet()
            if let diarys = result?.diarys {
                for value in diarys {
                    let use = value as! DiaryInfo
                    
                    if use.date == diaryDate {
                        use.date = diaryDate
                        use.title = newModel.title
                        use.weather = newModel.weather
                        use.mood = newModel.mood
                        use.richText = newModel.richText
                        use.images = newModel.images
                    }
                    
                    tempDiarys.add(use)
                }
            }
            
            result?.diarys = tempDiarys
            
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
        }
        
        saveContext()
    }
}

/*
 // 增加数据
 func savePersonWith(name: String, age: Int16) {
    let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person
    person.name = name
    person.age = age
    saveContext()
 }
 
 // 根据姓名获取数据
 func getPersonWith(name: String) -> [Person] {
     let fetchRequest: NSFetchRequest = Person.fetchRequest()
     fetchRequest.predicate = NSPredicate(format: "name == %@", name)
     do {
         let result: [Person] = try context.fetch(fetchRequest)
         return result
     } catch {
         fatalError();
     }
 }
 
 // 获取所有数据
 func getAllPerson() -> [Person] {
     let fetchRequest: NSFetchRequest = Person.fetchRequest()
     do {
         let result = try context.fetch(fetchRequest)
         return result
     } catch {
         fatalError();
     }
 }
 
 // 根据姓名修改数据
 func changePersonWith(name: String, newName: String, newAge: Int16) {
     let fetchRequest: NSFetchRequest = Person.fetchRequest()
     fetchRequest.predicate = NSPredicate(format: "name == %@", name)
     do {
         let result = try context.fetch(fetchRequest)
         for person in result {
             person.name = newName
             person.age = newAge
         }
     } catch {
         fatalError();
     }
     saveContext()
 }
 
 // 根据姓名删除数据
 func deleteWith(name: String) {
     let fetchRequest: NSFetchRequest = Person.fetchRequest()
     fetchRequest.predicate = NSPredicate(format: "name == %@", name)
     do {
         let result = try context.fetch(fetchRequest)
         for person in result {
             context.delete(person)
         }
     } catch {
         fatalError();
     }
     saveContext()
 }
 
 // 删除所有数据
 func deleteAllPerson() {
     let result = getAllPerson()
     for person in result {
         context.delete(person)
     }
     saveContext()
 }
 */
