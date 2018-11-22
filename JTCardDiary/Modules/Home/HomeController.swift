//
//  HomeController.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/13.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import SnapKit

class HomeController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var yearArrowImg: UIImageView!
    
    var monthData: [MonthModel] = []
    
    private var isShowCalendar = false
    
    // MARK: - scroll prop
    private var _currentIndex: Int = 0
    private var _dragStartX: CGFloat = 0
    private var _dragEndX: CGFloat = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _currentIndex = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationBarHairLine()
        
        initData()
        setUpUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        self.collectionView.scrollToItem(at: IndexPath(item: _currentIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
    }
    
    @IBAction func calendarBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isShowCalendar = sender.isSelected
        if sender.isSelected {
            self.flipToCalendar()
        } else {
            self.flipToShowImg()
        }
    }
    
    
    
    private func flipToCalendar() {
        let cells = self.collectionView.visibleCells as! [HomeCell]
        for value in cells {
            UIView.transition(with: value, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromRight, animations: {
                value.isCalendar = true
            }) { (finished) in
                
            }
        }
    }
    
    private func flipToShowImg() {
        let cells = self.collectionView.visibleCells as! [HomeCell]
        for value in cells {
            UIView.transition(with: value, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
                value.isCalendar = false
            }) { (finished) in
                
            }
        }
    }
    
    @IBAction func dateBtnClick(_ sender: UIButton) {
        let vc = DatePickerController()
        vc.modalPresentationStyle = .overCurrentContext
        
        if let year = self.yearLbl.text {
            vc.setDate(month: self._currentIndex, year: year)
        }
        
        vc.jumpToDate = { month, year in
            print(month)
            print(year)
            
            self.yearLbl.text = "\(year)"
            self._currentIndex = month-1
            self.collectionView.scrollToItem(at: IndexPath(item: self._currentIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
        
        self.present(vc, animated: false) {
            
        }
    }
    
    @IBAction func todayBtnClick(_ sender: UIButton) {
        // 年份  及 月份显示  滚到今日
        self.yearLbl.text = CurrentYear
        
        self._currentIndex = Int(CurrentMonth)! - 1
        
        self.collectionView.scrollToItem(at: IndexPath(item: _currentIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    
    @IBAction func writeTodayBtnClick(_ sender: UIButton) {
        
        
    }
    
    
    @objc func searchItemClick(_ sender: UIBarButtonItem) {
        print("search")
        
    }
    
    @objc func settingItemClick(_ sender: UIBarButtonItem) {
        print("setting")
        
    }
    
}

// MARK: - private setting
extension HomeController {
    private func initData() {
        let colorArr = ["AFDFCC", "4D839B", "FABD6B", "E35A49", "3AADEF", "B1E2FF", "A7D7CB", "FCE85A", "82CAF2", "C9FF87", "6AECD2", "A1E0EF"]
        let daysArr = JTDateUtils.getMonthDays(Date())
        let months = JTDateUtils.getMonths(Date())
        for (index, value) in colorArr.enumerated() {
            let model = MonthModel.init(date: months[index], cover: nil, color: value, totalDays: daysArr[index], isWrited: 5)
            self.monthData.append(model)
        }
    }
    
    private func setUpUI() {
        self.collectionView.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize =
        layout.minimumLineSpacing = 30
        layout.scrollDirection = .horizontal
        
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.collectionViewLayout = layout
        
        self.dateView.layer.borderWidth = 1
        self.dateView.layer.borderColor = UIColor.hexString(hexString: "8E8E93").cgColor
        
        // avatar button custom view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(searchItemClick(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(settingItemClick(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.hexString(hexString: "2D2D2D")
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.hexString(hexString: "2D2D2D")
        
        // date weather
        let year = CurrentYear
        let month = CurrentMonth
        let day = CurrentDay
        
        let dateText = MonthSubDic[month]! + ", " + "\(day)" + " / " + "\(year)"
        self.dateLbl.text = dateText
    }
    
    
    
}


extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.monthData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOpacity = 0.4
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowPath = UIBezierPath(rect: CGRect(x: -2, y: -2, width: cell.bounds.size.width + 4, height: cell.bounds.size.height + 4)).cgPath
        
        //设置缓存
        cell.layer.shouldRasterize = true
        
        //设置抗锯齿边缘
        cell.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        cell.isCalendar = self.isShowCalendar
        cell.setMonthModel(model: self.monthData[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth*0.7, height: self.collectionView.height-20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin = kScreenWidth/2.0 - (kScreenWidth*0.7)/2.0
        return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HomeCell
        
        if cell.isCalendar { return }
        
        var title = ""
        if let date = cell.monthModel?.date {
            let arr = date.components(separatedBy: "-")
            let year = arr.first!
            let month = MonthDic[arr.last!]!
            title = month + " / " + year
        }
        
        
        
        // 进入当月列表
        let vc = DiaryListController()
        vc.setTitle(title: title)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //手指拖动开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self._dragStartX = scrollView.contentOffset.x
    }
    
    //手指拖动停止
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self._dragEndX = scrollView.contentOffset.x
        
        DispatchQueue.main.async {
            self.fixCellToCenter()
        }
    }
    
    //配置cell居中
    private func fixCellToCenter() {
        //最小滚动距离
        let dragMiniDistance: CGFloat = kScreenWidth*0.5*0.2
        if _dragStartX - _dragEndX >= dragMiniDistance {
            _currentIndex -= 1  // 向右
        } else if _dragEndX - _dragStartX >= dragMiniDistance {
            _currentIndex += 1   // 向左
        }
        
        let maxIndex = self.collectionView.numberOfItems(inSection: 0) - 1
        self._currentIndex = _currentIndex <= 0 ? 0 : _currentIndex
        self._currentIndex = _currentIndex >= maxIndex ? maxIndex : _currentIndex
    
        self.collectionView.scrollToItem(at: IndexPath(item: _currentIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    
}
