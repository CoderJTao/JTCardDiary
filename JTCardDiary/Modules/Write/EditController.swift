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
import AVFoundation

class EditController: UIViewController {
    
    fileprivate var progressHud: JGProgressHUDWrapper?
    
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
    
    private var colorView: ColorView = {
        let view = ColorView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 300))
        return view
    }()
    
    @IBOutlet weak var bgmView: UIView!
    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
    @IBOutlet weak var bgmImg: UIImageView!
    @IBOutlet weak var bgmName: UILabel!
    @IBOutlet weak var bgmArtistName: UILabel!
    private var bgmPath: String?
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var textView: JTRichTextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var diaryModel: DiaryModel?
    
    var weatherStr = ""
    var moodStr = ""
    
    var bgmModel: BgmModel?
    
    
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
    
    func setDiaryModel(model: DiaryModel) {
        self.diaryModel = model
        
        if let bgm = model.bgm {
            //            self.bgmImg.image =
            self.bgmName.text = bgm.musicName
            self.bgmArtistName.text = bgm.artistName
        } else {
            self.bgmView.isHidden = true
            self.heightConstraints.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    func setText(text: NSAttributedString) {
        self.currentText = NSMutableAttributedString(attributedString: text)
    }
}
// MARK: - 自身的私有方法
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
        
        if let model = self.diaryModel {
            if let bgm = model.bgm {
                self.bgmView.isHidden = false
                self.heightConstraints.constant = 50
                self.bgmView.layer.masksToBounds = false
                self.view.layoutIfNeeded()
                //            self.bgmImg.image =
                self.bgmName.text = bgm.musicName
                self.bgmArtistName.text = bgm.artistName
            } else {
                self.bgmView.isHidden = true
                self.heightConstraints.constant = 0
                self.bgmView.layer.masksToBounds = true
                self.view.layoutIfNeeded()
            }
        } else {
            self.bgmView.isHidden = true
            self.heightConstraints.constant = 0
            self.bgmView.layer.masksToBounds = true
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func moodAndWeatherBtnClick() {
        let vc = MoodAndWeatherController()
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.setShowImg(weather: self.weatherStr, mood: self.moodStr)
        
        vc.passWeatherAndMood = { (weather, mood) in
            if !weather.isEmpty {
                self.weatherStr = weather
                self.imageWeather.image = UIImage(named: WeatherDic[weather] ?? "yintian")
            }
            
            if !mood.isEmpty {
                self.moodStr = mood
                self.imageMood.image = UIImage(named: MoodDic[mood] ?? "happy")
            }
        }
        
        self.present(vc, animated: false) {
            
        }
    }
    
    @objc private func saveItemClick(_ sender: UIBarButtonItem) {
        print("保存")
        
        let diaryModel = DiaryModel.init(title: self.titleTF.text, weather: WeatherDic[self.weatherStr], mood: MoodDic[self.moodStr], bgm: self.bgmModel, richText: self.textView.attributedText.transformToArray())
        
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

// MARK: - UITextViewDelegate, UITextFieldDelegate
extension EditController: UITextViewDelegate, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        guard let str = self.textView.text else {
//            return
//        }
//        let tempStr = NSString(string: str)
//
//        let len = self.textView.attributedText.length - self.textView.locationStr.length
//
//        if len > 0 {
//            self.textView.newRange = NSRange(location: self.textView.selectedRange.location-len, length: len)
//            self.textView.newStr = tempStr.substring(with: self.textView.newRange)
//        }
//
//        var isChinese: Bool
//        if let mode = self.textView.textInputMode?.primaryLanguage, mode == "en-US" {
//            isChinese = false
//        } else {
//            isChinese = true
//        }
//
//        let use = tempStr.replacingOccurrences(of: "?", with: "")
//        if isChinese {
//            if let selectedRange = self.textView.markedTextRange {
//                // 获取高亮部分
//                // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//                if let _ = self.textView.position(from: selectedRange.start, offset: 0) {
//
//                    self.textView.setStyle()
//                } else {
//                    print("没有转化" + use)
//                }
//            }
//        } else {
//            self.textView.setStyle()
//        }
    }
}

// MARK: - 键盘上l扩展方法的回调
extension EditController: KeyBoardExtensionDelegate {
    func photoPressed(_ sender: UIButton) {
        print("照片点击")
        
        self.colorView.removeFromSuperview()
        self.fontView.removeFromSuperview()
        
        let vc = PhotoController()
        vc.setType(type: .image)
        let nav = UINavigationController(rootViewController: vc)
        
        vc.importImageClick = { assets in
            self.importImageHandle(assets: assets)
        }
        
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization() { status in
                if status == .authorized {
                    print("authorized")
                    
                    DispatchQueue.main.async {
                        
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
            self.present(nav, animated: true, completion: {
                
            })
        }
    }
    
    func videoPressed(_ sender: UIButton) {
        print("视频点击")
        
        self.colorView.removeFromSuperview()
        self.fontView.removeFromSuperview()
        
        let vc = PhotoController()
        vc.setType(type: .video)
        let nav = UINavigationController(rootViewController: vc)
        
        vc.importVideoClick = { item in
            self.importVideoHandle(playItem: item)
        }
        
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization() { status in
                if status == .authorized {
                    print("authorized")
                    
                    DispatchQueue.main.async {
                        
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
            self.present(nav, animated: true, completion: {
                
            })
        }
    }
    
    func bgmPressedn(_ sender: UIButton) {
        print("音乐点击")
        
        self.colorView.removeFromSuperview()
        self.fontView.removeFromSuperview()
        
        let vc = MusicController()
        let nav = UINavigationController(rootViewController: vc)
        
        vc.importMusicClick = { bgm in
            self.importMusicHandle(bgm: bgm)
        }
        
        if MPMediaLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization() { status in
                if status == .authorized {
                    print("authorized")
                    
                    DispatchQueue.main.async {
                        
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
            self.present(nav, animated: true, completion: {
                
            })
        }
    }
    
    func fontPressed(_ sender: UIButton) {
        print("字体点击")
        self.colorView.removeFromSuperview()
        
        if sender.isSelected {
            self.fontView.frame = CGRect(x: 0, y: kScreenHeight-self.keyboardHeight, width: kScreenWidth, height: self.keyboardHeight)
            self.view.addSubview(self.fontView)
            
            self.fontView.fontClick = { style, isSet in
                self.refreshTextViewStyle(style: style, isSet: isSet)
            }
            
        } else {
            self.fontView.removeFromSuperview()
        }
        
        isHideKB(isHide: sender.isSelected)
    }
    
    func colorPickerPressed(_ sender: UIButton) {
        print("色板点击")
        self.fontView.removeFromSuperview()
        
        if sender.isSelected {
            self.colorView.frame = CGRect(x: 0, y: kScreenHeight-self.keyboardHeight, width: kScreenWidth, height: self.keyboardHeight)
            self.view.addSubview(self.colorView)
            
            self.colorView.colorClick = { (colorStr) in
                sender.isSelected = false
                self.textView.color = UIColor.hexString(hexString: colorStr)
                self.isHideKB(isHide: false)
                self.colorView.removeFromSuperview()
            }
            
        } else {
            self.colorView.removeFromSuperview()
        }
        
        isHideKB(isHide: sender.isSelected)
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

// MARK: - 处理导入数据 图片 视频 音乐
extension EditController {
    private func importImageHandle(assets: [PHAsset]) {
        if self.progressHud == nil {
            self.progressHud = JGProgressHUDWrapper()
        }
        
        self.progressHud?.show(self.view, completion: nil)
        
        for value in assets {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            PHImageManager.default().requestImage(for: value, targetSize: CGSize(width: value.pixelWidth, height: value.pixelHeight), contentMode: PHImageContentMode.default, options: options) { (image, imageInfo) in
                guard let temp = image else { return }
                
                DispatchQueue.main.async {
                    self.textView.insertImage(image: temp)
                }
            }
        }
        
        self.progressHud?.dismiss(nil)
    }
    
    private func importVideoHandle(playItem: AVPlayerItem) {
        if self.progressHud == nil {
            self.progressHud = JGProgressHUDWrapper()
        }
        
        self.progressHud?.show(self.view, completion: nil)
        
        
        
    }
    
    private func importMusicHandle(bgm: MPMediaItem) {
        if self.progressHud == nil {
            self.progressHud = JGProgressHUDWrapper()
        }
        
        self.progressHud?.show(self.view, completion: nil)
        
        if let show = bgm.artwork?.image(at: CGSize(width: 100, height: 100)) {
            self.bgmImg.image = show
        }
        
        if let songTitle = bgm.value(forProperty: MPMediaItemPropertyTitle) as? String {
            self.bgmName.text = songTitle
        }
        
        if let songArt = bgm.value(forProperty: MPMediaItemPropertyArtist) as? String {
            self.bgmArtistName.text = songArt
        }
        
        if let path = bgm.value(forProperty: MPMediaItemPropertyAssetURL) as? URL {
            self.bgmPath = path.absoluteString
        }
        
        self.bgmView.isHidden = false
        self.heightConstraints.constant = 50
        self.bgmView.layer.masksToBounds = false
        self.view.layoutIfNeeded()
        
        self.progressHud?.dismiss(nil)
        
    }
    
    private func refreshTextViewStyle(style: JTFontFormat, isSet: Bool) {
        switch style {
        case .alignLeft, .alignCenter, .alignRight:
            self.textView.alignType = style
        case .indent:
            self.textView.isIndent = isSet
        case .beBold:
            self.textView.isBold = isSet
        case .beItalic:
            self.textView.isOblique = isSet
        case .underLine:
            self.textView.isUnderline = isSet
        case .throughLine:
            self.textView.isThrough = isSet
        case .listOL:
            self.textView.isListOL = isSet
        case .listUL:
            self.textView.isListUL = isSet
        case .divider:
            self.textView.addDividerLine = true
        default:
            break
        }
        
        
    }
}
