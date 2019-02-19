//
//  DatePickerController.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/15.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

//返回值是String
//typealias jumpToDate = (Int,Int) -> ()

class DatePickerController: UIViewController {
    
     var jumpToDate : ((Int,Int) -> ())!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var monthTableView: UITableView!
    @IBOutlet weak var yearTableView: UITableView!
    
    private var selectMonthIndex = Int(CurrentMonth)! - 1
    private var selectYearIndex = 5
    
    private let monthData = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
    private var yearData: [String] {
        get {
            var arr: [String] = []
            let year = Int(CurrentYear)!
            
            for index in (year-5)...(year+4) {
                arr.append("\(index)")
            }
            return arr
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.monthTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MonthCell")
        self.yearTableView.register(UITableViewCell.self, forCellReuseIdentifier: "YearCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.monthTableView.scrollToRow(at: IndexPath(row: self.selectMonthIndex, section: 0), at: UITableView.ScrollPosition.middle, animated: true)
        self.yearTableView.scrollToRow(at: IndexPath(row: self.selectYearIndex, section: 0), at: UITableView.ScrollPosition.middle, animated: true)
    }
    
    
    func setDate(month: Int, year: String) {
        self.selectMonthIndex = month
        
        let currentYear = Int(CurrentYear)!
        let passYear = Int(year)!
        
        let index = currentYear - passYear
        self.selectYearIndex = self.selectYearIndex - index
    }
    

    @IBAction func backBtnClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.bottomConstraint.constant = 300
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func moveBtnClick(_ sender: UIButton) {
        self.jumpToDate(self.selectMonthIndex+1, (Int(CurrentYear)!-5)+self.selectYearIndex)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.bottomConstraint.constant = 300
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}


extension DatePickerController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.monthTableView {
            return self.monthData.count
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        if tableView == self.monthTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MonthCell", for: indexPath)
            cell.textLabel?.textColor = UIColor.hexString(hexString: "8E8E93")
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            
            cell.textLabel?.text = monthData[indexPath.row] + " " + "(" + "\(indexPath.row)" + ")"
            
            if indexPath.row == self.selectMonthIndex {
                cell.textLabel?.textColor = UIColor.hexString(hexString: "2D2D2D")
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YearCell", for: indexPath)
            cell.textLabel?.textColor = UIColor.hexString(hexString: "8E8E93")
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            
            cell.textLabel?.text = yearData[indexPath.row]
            
            if indexPath.row == self.selectYearIndex {
                cell.textLabel?.textColor = UIColor.hexString(hexString: "2D2D2D")
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == self.monthTableView {
            self.selectMonthIndex = indexPath.row
        } else {
            self.selectYearIndex = indexPath.row
        }
        
        tableView.reloadData()
    }
}

