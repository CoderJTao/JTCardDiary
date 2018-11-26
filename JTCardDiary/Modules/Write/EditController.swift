//
//  EditController.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/19.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import Photos
import MediaPlayer

class EditController: UIViewController {
    
    private var currentText = NSMutableAttributedString()
    
    private var keyboardHeight: CGFloat = 0
    
    private var imageMood: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 140, y: 10, width: 16, height: 16))
        image.image = UIImage(named: "happy")
        image.contentMode = UIView.ContentMode.scaleAspectFit
        return image
    }()
    private var imageWeather: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 160, y: 10, width: 16, height: 16))
        image.image = UIImage(named: "yintian")
        image.contentMode = UIView.ContentMode.scaleAspectFit
        return image
    }()
    
    private var keyBoardTopView: KeyBoardExtensionView = {
        let view = KeyBoardExtensionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44))
        return view
    }()
    
    private var fontView: FormatView = {
        let view = Bundle.main.loadNibNamed("FormatView", owner: self, options: nil)?[0] as! FormatView
        return view
    }()
    
    @IBOutlet weak var bgmView: UIView!
    
    
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
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
        
        let lbl = UILabel(frame: CGRect(x: 0, y: 8, width: 120, height: 20))
        lbl.textAlignment = .center
        lbl.textColor = UIColor.hexString(hexString: TextColor_black)
        lbl.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        lbl.text = "NOV, 23 / 2018"
        titleView.addSubview(lbl)
        lbl.center = CGPoint(x: titleView.center.x-25, y: titleView.center.y)
        
        let btn = UIButton(frame: titleView.bounds)
        btn.addTarget(self, action: #selector(moodAndWeatherBtnClick), for: .touchUpInside)
        
        titleView.addSubview(imageMood)
        titleView.addSubview(imageWeather)
        titleView.addSubview(btn)
        
        titleView.clipsToBounds = true
        titleView.layer.borderWidth = 1
        titleView.layer.borderColor = UIColor.hexString(hexString: TextColor_gray).cgColor
        titleView.layer.cornerRadius = 18
        
        self.navigationItem.titleView = titleView
    }
    
    @objc private func moodAndWeatherBtnClick() {
        let vc = MoodAndWeatherController()
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.passWeatherAndMood = { (weather, mood) in
            if !weather.isEmpty {
                self.imageWeather.image = UIImage(named: WeatherDic[weather] ?? "yintian")
            }
            
            if !mood.isEmpty {
                self.imageMood.image = UIImage(named: MoodDic[mood] ?? "happy")
            }
        }
        
        self.present(vc, animated: false) {
            
        }
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
        
        
        //  kb
        self.keyBoardTopView.delegate = self
        self.textView.inputAccessoryView = self.keyBoardTopView
        
        // 为bgmView添加背景
        self.bgmView.layer.shadowColor = UIColor.gray.cgColor
        self.bgmView.layer.shadowOpacity = 0.4
        self.bgmView.layer.shadowRadius = 4.0
        self.bgmView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.bgmView.layer.shadowPath = UIBezierPath(rect: CGRect(x: -2, y: -2, width: kScreenWidth - 30 + 4, height: 50 + 4)).cgPath
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
            self.bottomConstraint.constant = 8 + kbHeight
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let info = notification.userInfo
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        let duration = (info?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        
        UIView.animate(withDuration: duration) {
            self.bottomConstraint.constant = 8
            self.view.layoutIfNeeded()
        }
    }
    
    
}

// MARK: - KeyBoardExtensionDelegate
extension EditController: KeyBoardExtensionDelegate {
    func photoPressed(_ sender: UIButton) {
        print("照片点击")
        
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization() { status in
                if status == .authorized {
                    print("authorized")
                    
                    DispatchQueue.main.async {
                        let vc = PhotoController()
                        vc.setType(type: .image)
                        let nav = UINavigationController(rootViewController: vc)
                        self.present(nav, animated: true, completion: {
                            
                        })
                    }
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .denied || PHPhotoLibrary.authorizationStatus() == .restricted {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: nil, message: "请在iPhone的\"设置-隐私-照片\"选项中，\n允许访问你的手机相册。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: { (act) in
                    
                }))
                alert.addAction(UIAlertAction(title: "前往", style: .default, handler: { (act) in
                    
                }))
                self.present(alert, animated: true, completion: {
                    
                })
            }
        } else {
            let vc = PhotoController()
            vc.setType(type: .image)
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: {
                
            })
        }
        
    }
    
    func videoPressed(_ sender: UIButton) {
        print("视频点击")
        
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization() { status in
                if status == .authorized {
                    print("authorized")
                    
                    DispatchQueue.main.async {
                        let vc = PhotoController()
                        vc.setType(type: .video)
                        let nav = UINavigationController(rootViewController: vc)
                        self.present(nav, animated: true, completion: {
                            
                        })
                    }
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .denied || PHPhotoLibrary.authorizationStatus() == .restricted {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: nil, message: "请在iPhone的\"设置-隐私-照片\"选项中，\n允许访问你的手机相册。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: { (act) in
                    
                }))
                alert.addAction(UIAlertAction(title: "前往", style: .default, handler: { (act) in
                    
                }))
                self.present(alert, animated: true, completion: {
                    
                })
            }
        } else {
            let vc = PhotoController()
            vc.setType(type: .video)
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: {
                
            })
        }
    }
    
    func bgmPressedn(_ sender: UIButton) {
        print("音乐点击")
        
        if MPMediaLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization() { status in
                if status == .authorized {
                    print("authorized")
                    
                    DispatchQueue.main.async {
                        let vc = MusicController()
                        let nav = UINavigationController(rootViewController: vc)
                        self.present(nav, animated: true, completion: {
                            
                        })
                    }
                }
            }
        } else if MPMediaLibrary.authorizationStatus() == .denied || MPMediaLibrary.authorizationStatus() == .restricted {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: nil, message: "请在iPhone的\"设置-隐私-照片\"选项中，\n允许访问你的手机音乐。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: { (act) in
                    
                }))
                alert.addAction(UIAlertAction(title: "前往", style: .default, handler: { (act) in
                    
                }))
                self.present(alert, animated: true, completion: {
                    
                })
            }
        } else {
            let vc = MusicController()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: {
                
            })
        }
        
        
        
    }
    
    func fontPressed(_ sender: UIButton) {
        print("字体点击")
        
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
        self.fontView.removeFromSuperview()
        
        self.textView.resignFirstResponder()
    }
    

    
}

