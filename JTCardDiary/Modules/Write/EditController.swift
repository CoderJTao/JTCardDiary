//
//  EditController.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/19.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import Photos

class EditController: UIViewController {
    
    private var currentText = NSMutableAttributedString()
    
    private var keyboardHeight: CGFloat = 0
    
    private var keyBoardTopView: KeyBoardExtensionView = {
        let view = KeyBoardExtensionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44))
        return view
    }()
    private var photoView: PhotoView = {
        let view = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?[0] as! PhotoView
        return view
    }()
    private var videoView: VideoView = {
        let view = Bundle.main.loadNibNamed("VideoView", owner: self, options: nil)?[0] as! VideoView
        return view
    }()
    
    private var fontView: FormatView = {
        let view = FormatView()
        return view
    }()
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationBackButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setUpUI()
    }

    func setDateTitle(title: String) {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        lbl.textAlignment = .center
        lbl.textColor = UIColor.hexString(hexString: TextColor_black)
        lbl.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        lbl.text = title
        self.navigationItem.titleView = lbl
    }
    
    func setText(text: NSAttributedString) {
        self.currentText = NSMutableAttributedString(attributedString: text)
    }
}

extension EditController {
    private func setUpUI() {
        self.textView.attributedText = self.currentText
        self.textView.becomeFirstResponder()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveItemClick(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.hexString(hexString: "2D2D2D")
        
        
        //  test
        self.keyBoardTopView.delegate = self
        self.textView.inputAccessoryView = self.keyBoardTopView
    }
    
    @objc func saveItemClick(_ sender: UIBarButtonItem) {
        print("保存")
    }
    
}


extension EditController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.textView.setContentOffset(CGPoint(x: self.textView.contentOffset.x, y: self.textView.contentSize.height), animated: true)
        
        return true
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        //获取键盘高度，在不同设备上，以及中英文下是不同的
        let info = notification.userInfo
        let kbHeight = (info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        self.keyboardHeight = kbHeight - 44
        
//        // 获取光标frame
//        let origin = textView.caretRect(for: (textView.selectedTextRange?.end)!).origin
//        let point = textView.convert(origin, to: self.view)
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        let duration = (info?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
//
//        //将视图上移计算好的偏移
        UIView.animate(withDuration: duration) {
            self.bottomConstraint.constant = 20 + kbHeight
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let info = notification.userInfo
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        let duration = (info?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        
        UIView.animate(withDuration: duration) {
            self.bottomConstraint.constant = 20
            self.view.layoutIfNeeded()
        }
    }
    
    
}

// MARK: - KeyBoardExtensionDelegate
extension EditController: KeyBoardExtensionDelegate {
    func photoPressed(_ sender: UIButton) {
        print("照片点击")
        
        if sender.isSelected {
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                print("authorized")
                self.photoView.initData()
            default:
                let alert = UIAlertController(title: nil, message: "请在iPhone的\"设置-隐私-照片\"选项中，\n允许访问你的手机相册。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: { (act) in
                    
                }))
                alert.addAction(UIAlertAction(title: "前往", style: .default, handler: { (act) in
                    
                }))
                self.present(alert, animated: true, completion: {
                    
                })
            }
        }
        
        self.videoView.removeFromSuperview()
        self.fontView.removeFromSuperview()
        
        if sender.isSelected {
            self.photoView.frame = CGRect(x: 0, y: kScreenHeight-self.keyboardHeight, width: kScreenWidth, height: self.keyboardHeight)
            self.view.addSubview(self.photoView)
        } else {
            self.photoView.removeFromSuperview()
        }
        
        self.isHideKB(isHide: sender.isSelected)
    }
    
    func videoPressed(_ sender: UIButton) {
        print("视频点击")
        
        if sender.isSelected {
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                print("authorized")
                self.videoView.initData()
            default:
                let alert = UIAlertController(title: nil, message: "请在iPhone的\"设置-隐私-照片\"选项中，\n允许访问你的手机相册。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: { (act) in
                    
                }))
                alert.addAction(UIAlertAction(title: "前往", style: .default, handler: { (act) in
                    
                }))
                self.present(alert, animated: true, completion: {
                    
                })
                
            }
        }
        
        self.photoView.removeFromSuperview()
        self.fontView.removeFromSuperview()
        
        if sender.isSelected {
            self.videoView.frame = CGRect(x: 0, y: kScreenHeight-self.keyboardHeight, width: kScreenWidth, height: self.keyboardHeight)
            self.view.addSubview(self.videoView)
        } else {
            self.videoView.removeFromSuperview()
        }
        
        self.isHideKB(isHide: sender.isSelected)
    }
    
    func bgmPressedn(_ sender: UIButton) {
        print("音乐点击")
    }
    
    func fontPressed(_ sender: UIButton) {
        print("字体点击")
        self.photoView.removeFromSuperview()
        self.videoView.removeFromSuperview()
        
        if sender.isSelected {
            self.fontView.frame = CGRect(x: 0, y: kScreenHeight-self.keyboardHeight, width: kScreenWidth, height: self.keyboardHeight)
            self.view.addSubview(self.fontView)
        } else {
            self.fontView.removeFromSuperview()
        }
        
        isHideKB(isHide: sender.isSelected)
    }
    
    func colorPickerPressed(_ sender: UIButton) {
        print("t色板点击")
    }
    
    private func isHideKB(isHide: Bool) {
        let array = UIApplication.shared.windows
        let kbWindow = array.last!
        if isHide {
            kbWindow.isHidden = true
        } else {
            kbWindow.isHidden = false
        }
    }
    
    func endPressed(_ sender: UIButton) {
        // 下降时 插入的视图也需要消失
        self.photoView.removeFromSuperview()
        self.fontView.removeFromSuperview()
        
        self.textView.resignFirstResponder()
    }
    

    
}

