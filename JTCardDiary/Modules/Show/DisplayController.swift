//
//  DisplayController.swift
//  JTCardDiary
//
//  Created by JiangT on 2018/11/18.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

class DisplayController: UIViewController {
    
    @IBOutlet weak var titleTF: UITextField!
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
        if let info = diaryInfo {
            vc.setDiaryModel(info: info)
        }
        
        vc.displayCallback = { info in
            self.diaryInfo = info
            
            self.setUpUI()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func likeBtnClick(_ sender: UIButton) {
        
    }
    
    @IBAction func deletBtnClick(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "您确定要删除当前文章么？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "删除", style: .destructive, handler: { (action) in
            if let info = self.diaryInfo {
                DiaryManager.sharedInstance.deleteADiary(info: info)
            }
            
            NotificationCenter.default.post(name: DeleteDiaryNotification, object: nil)
            
            self.navigationController?.popViewController(animated: true)
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
        
        self.titleTF.text = useModel.title
        self.dateLbl.text = useModel.date
        
        if let text = useModel.richText {
            self.countLbl.text = "字数：\(text.length)"
        }
        
        if let use = useModel.mood {
            self.moodImg.image = UIImage(named: MoodDic[use]!)
        }
        
        if let use = useModel.weather {
            self.weatherImg.image = UIImage(named: WeatherDic[use]!)
        }
        
        // attributedText  insert images
        self.textView.attributedText = useModel.richText
        
        var storImgArr: [StoreImgModel] = []
        if let images = useModel.images {
            for value in images {
                let use = value as! StoreImgInfo
                let model = StoreImgModel.init(insetIndex: Int(use.insertIndex), imgData: use.imgData)
                storImgArr.append(model)
            }
        }
        
        storImgArr.sort { (one, two) -> Bool in
            return one.insetIndex > two.insetIndex
        }
        
        if let atbStr = useModel.richText {
            self.textView.attributedText = atbStr
            
            let mutableStr = NSMutableAttributedString(attributedString: atbStr)
            
            for value in storImgArr {
                let image = UIImage(data: value.imgData!)!
                
                //创建图片附件
                let imgAttachment = NSTextAttachment(data: nil, ofType: nil)
                imgAttachment.image = image
                
                //设置图片显示方式
                //撑满一行
                let imageWidth = kScreenWidth-30
                let imageHeight = image.size.height/image.size.width*imageWidth
                imgAttachment.bounds = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
                
                let insertStr = NSAttributedString(attachment: imgAttachment)
                
                mutableStr.insert(insertStr, at: value.insetIndex)
            }
            
            self.textView.attributedText = mutableStr
        }
    }
}
