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
    
    @IBOutlet weak var bgmView: UIView!
    @IBOutlet weak var bgmViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgmImg: UIImageView!
    @IBOutlet weak var bgmName: UILabel!
    @IBOutlet weak var bgmArtistName: UILabel!
    
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var funcView: UIView!
    
    private var attText = NSAttributedString()
    
    var diaryModel: DiaryModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationBackButton()
        setNavigationBarBackGroundColor()
        
        self.textView.attributedText = self.attText
        
        setUpUI()
    }
    
    func setDiaryModel(model: DiaryModel) {
        self.diaryModel = model
        
        if let bgm = model.bgm {
//            self.bgmImg.image =
            self.bgmName.text = bgm.musicName
            self.bgmArtistName.text = bgm.artistName
        } else {
            self.bgmView.isHidden = true
            self.bgmViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    func setText(text: NSAttributedString) {
        self.attText = text
    }
    
    @IBAction func editBtnClick(_ sender: UIButton) {
        let vc = EditController()
        vc.setText(text: self.attText)
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
        // 为bgmView添加背景
        self.bgmView.layer.shadowColor = UIColor.gray.cgColor
        self.bgmView.layer.shadowOpacity = 0.4
        self.bgmView.layer.shadowRadius = 4.0
        self.bgmView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.bgmView.layer.shadowPath = UIBezierPath(rect: CGRect(x: -2, y: -2, width: kScreenWidth - 30 + 4, height: 50 + 4)).cgPath
        
        
    }
    
    
}
