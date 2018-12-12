//
//  DisplayController.swift
//  JTCardDiary
//
//  Created by JiangT on 2018/11/18.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

class DisplayController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var moodImg: UIImageView!
    @IBOutlet weak var weatherImg: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var funcView: UIView!
    
    private var attText = NSAttributedString()
    
    var diaryInfo: DiaryInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationBackButton()
        setNavigationBarBackGroundColor()
        
        self.textView.attributedText = self.attText
        
        setUpUI()
    }
    
    func setDiary(info: DiaryInfo) {
        self.diaryInfo = info
    }
    
    @IBAction func editBtnClick(_ sender: UIButton) {
        let vc = EditController()
        vc.setDateTitle(title: "2018-11-19")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func likeBtnClick(_ sender: UIButton) {
        
    }
    
    @IBAction func deletBtnClick(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "您确定要删除当前文章么？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "删除", style: .destructive, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareBtnClick(_ sender: UIButton) {
        print("分享")
    }
    
}

extension DisplayController {
    private func setUpUI() {
        guard let useModel = self.diaryInfo else {
            return
        }
        
        self.titleLbl.text = useModel.title
        self.dateLbl.text = useModel.date
        
        if let text = useModel.normalText {
            let count = NSString(string: text).length
            self.countLbl.text = "字数：\(count)"
        }
        
        if let use = useModel.mood {
            self.moodImg.image = UIImage(named: MoodDic[use]!)
        }
        
        if let use = useModel.weather {
            self.weatherImg.image = UIImage(named: WeatherDic[use]!)
        }
        
    }
    
    private func getShowAttributedString() {
        guard let useModel = self.diaryInfo else {
            return
        }
        
        
        
//        guard let atbStr = useModel.ric else {
//
//        }
        
        
        
        
    }
    
    
}
