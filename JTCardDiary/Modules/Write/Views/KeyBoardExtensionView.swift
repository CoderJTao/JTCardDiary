//
//  KeyBoardExtensionView.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/20.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

protocol KeyBoardExtensionDelegate: AnyObject {
    func photoPressed(_ sender: UIButton)
    
    func videoPressed(_ sender: UIButton)
        
    func fontPressed(_ sender: UIButton)
    
    func colorPickerPressed(_ sender: UIButton)
    
    func endPressed(_ sender: UIButton)
}

class KeyBoardExtensionView: UIView {
    
    weak var delegate: KeyBoardExtensionDelegate?
    
    private let btnWidthHeight: CGFloat = 44
    private let margin: CGFloat = 4
    
    private lazy var photoBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 12+(btnWidthHeight+margin)*0, y: 0, width: btnWidthHeight, height: btnWidthHeight))
        btn.addTarget(self, action: #selector(self.photoBtnClick(_:)), for: .touchUpInside)
        
        btn.setImage(UIImage(named: "photo"), for: .normal)
        btn.setImage(UIImage(named: "photo_s"), for: .selected)
        
        return btn
    }()
    
    private lazy var videoBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 12+(btnWidthHeight+margin)*1, y: 0, width: btnWidthHeight, height: btnWidthHeight))
        btn.addTarget(self, action: #selector(self.videoBtnClick(_:)), for: .touchUpInside)
        
        btn.setImage(UIImage(named: "video"), for: .normal)
        btn.setImage(UIImage(named: "video_s"), for: .selected)
        
        return btn
    }()
    
    private lazy var fontBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 12+(btnWidthHeight+margin)*2, y: 0, width: btnWidthHeight, height: btnWidthHeight))
        btn.addTarget(self, action: #selector(self.fontBtnClick(_:)), for: .touchUpInside)
        
        btn.setImage(UIImage(named: "font"), for: .normal)
        btn.setImage(UIImage(named: "font_s"), for: .selected)
        
        return btn
    }()
    
    private lazy var colorBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 12+(btnWidthHeight+margin)*3, y: 0, width: btnWidthHeight, height: btnWidthHeight))
        btn.addTarget(self, action: #selector(self.colorBtnClick(_:)), for: .touchUpInside)
        
        btn.setImage(UIImage(named: "color_picker"), for: .normal)
        btn.setImage(UIImage(named: "color_picker_s"), for: .selected)
        
        return btn
    }()
    
    private lazy var endBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: kScreenWidth-btnWidthHeight-12, y: 0, width: btnWidthHeight, height: btnWidthHeight))
        btn.addTarget(self, action: #selector(self.hideKBBtnClick(_:)), for: .touchUpInside)
        
        btn.setImage(UIImage(named: "arrow_down"), for: .normal)
        
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension KeyBoardExtensionView {
    private func setUpUI() {
        addSubview(photoBtn)
        addSubview(videoBtn)
        addSubview(fontBtn)
        addSubview(colorBtn)
        addSubview(endBtn)
    }
    
    @objc func photoBtnClick(_ sender: UIButton) {
        self.videoBtn.isSelected = false
        self.fontBtn.isSelected = false
        self.colorBtn.isSelected = false
        
        self.fontBtn.isSelected = false
        self.colorBtn.isSelected = false
        
        self.delegate?.photoPressed(sender)
    }
    
    @objc func videoBtnClick(_ sender: UIButton) {
        self.photoBtn.isSelected = false
        self.fontBtn.isSelected = false
        self.colorBtn.isSelected = false
        
        self.fontBtn.isSelected = false
        self.colorBtn.isSelected = false
        
        self.delegate?.videoPressed(sender)
    }
    
    @objc func fontBtnClick(_ sender: UIButton) {
        self.photoBtn.isSelected = false
        self.videoBtn.isSelected = false
        self.colorBtn.isSelected = false
        
        sender.isSelected = !sender.isSelected
        
        self.delegate?.fontPressed(sender)
    }
    
    @objc func colorBtnClick(_ sender: UIButton) {
        self.photoBtn.isSelected = false
        self.videoBtn.isSelected = false
        self.fontBtn.isSelected = false
        
        sender.isSelected = !sender.isSelected
        
        self.delegate?.colorPickerPressed(sender)
    }
    
    @objc func hideKBBtnClick(_ sender: UIButton) {
        self.photoBtn.isSelected = false
        self.videoBtn.isSelected = false
        self.fontBtn.isSelected = false
        self.colorBtn.isSelected = false
        
        self.delegate?.endPressed(sender)
    }
}
