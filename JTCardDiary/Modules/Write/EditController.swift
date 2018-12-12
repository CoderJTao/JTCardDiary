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
import AVKit

class EditController: UIViewController {
    
    fileprivate var progressHud: JGProgressHUDWrapper?
    
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
    
    private var preView: PreviewView = {
        let view = PreviewView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        return view
    }()
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var textView: JTRichTextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var isFixOffset = false
    
    @IBOutlet weak var imgContainerView: UIView!
    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var imgCountLbl: UILabel!
    
    private var importImgLists: [StoreImgModel] = []
    
    var inputDiaryModel: DiaryModel?
    private var currentDiarModel: DiaryModel {
        get {
            return DiaryModel.init(date: JTDateUtils.stringFromDate(date: Date()), title: (self.titleTF.text ?? ""), weather: self.weatherStr, mood: self.moodStr, richText: self.textView.attributedText, normalText: self.textView.text, images: self.importImgLists)
        }
    }
    
    var weatherStr = "阴天"
    var moodStr = "开心"
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationBackButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setUpUI()
    }
    
    override func onNavigationBackPressed(_ sender: Any) {
        guard let model = self.inputDiaryModel else {
            // 提示保存
            if self.textView.text.isEmpty && self.importImgLists.count == 0 {
                self.navigationController?.popViewController(animated: true)
            } else {
                alertToSave()
            }
            return
        }
        
        if model.isEqual(model: currentDiarModel) {
            self.navigationController?.popViewController(animated: true)
        } else {
            alertToSave()
        }
    }
    
    private func alertToSave() {
        let alert = UIAlertController(title: nil, message: "日记没有保存，确定退出吗？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "退出", style: .destructive, handler: { (act) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
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
        self.inputDiaryModel = model
    }
}
// MARK: - 自身的私有方法
extension EditController {
    private func setUpUI() {
        self.textView.becomeFirstResponder()
        
        self.textView.alwaysBounceVertical = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveItemClick(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.hexString(hexString: "2D2D2D")
        
        //  kb
        self.keyBoardTopView.delegate = self
        self.textView.inputAccessoryView = self.keyBoardTopView
        
        self.coverImg.isUserInteractionEnabled = true
        self.coverImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(importImagesPreview)))
        
        if let model = self.inputDiaryModel {
            self.titleTF.text = model.title
            
            self.imageWeather.image = UIImage(named: WeatherDic[model.weather] ?? "yintian")
            self.imageMood.image = UIImage(named: MoodDic[model.mood] ?? "happy")
            
            self.textView.attributedText = model.richText
            
            self.importImgLists = model.images
            
            if self.importImgLists.count > 0 {
                self.imgContainerView.isHidden = false
                
                if let firstModel = self.importImgLists.first {
                    if let use = firstModel.imgData {
                        self.coverImg.image = UIImage(data: use)
                    }
                }
                
                self.imgCountLbl.text = String(self.importImgLists.count)
            }
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
    
    @objc private func importImagesPreview() {
        self.textView.resignFirstResponder()
        
        let vc = PreviewController()
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.setSources(images: self.importImgLists)
        
        vc.imagesChanged = { imagesData in
            self.importImgLists = imagesData
            
            if self.importImgLists.count == 0 {
                self.imgContainerView.isHidden = true
            } else {
                self.imgContainerView.isHidden = false
                
                if let firstModel = self.importImgLists.first {
                    if let use = firstModel.imgData {
                        self.coverImg.image = UIImage(data: use)
                    }
                }
                
                self.imgCountLbl.text = String(self.importImgLists.count)
            }
        }
        
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc private func saveItemClick(_ sender: UIBarButtonItem) {
        if self.inputDiaryModel != nil {
            // 更新原来的日记
            if currentDiarModel.isEqual(model: self.inputDiaryModel!) {
                // 如果没有任何修改，则返回
                self.navigationController?.popViewController(animated: true)
                return
            }
            DiaryManager.sharedInstance.updateADiary(model: currentDiarModel)
            
            // 保存完了，返回
            self.navigationController?.popViewController(animated: true)
            
        } else {
            // 新增当天日记
            if currentDiarModel.images.count == 0 && self.textView.text.isEmpty {
                self.showAlert(title: nil, msg: "您还什么都没写呢。")
                return
            }
            DiaryManager.sharedInstance.addANewDiary(model: currentDiarModel)
            
            // 保存完了，返回
            self.navigationController?.popViewController(animated: true)
        }
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
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        ///防止拼音输入时，文本直接获取拼音
        if textView.markedTextRange == nil {
            // 没有预输入文字
            
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
}

// MARK: - 键盘上l扩展方法的回调
extension EditController: KeyBoardExtensionDelegate {
    func photoPressed(_ sender: UIButton) {
        print("照片点击")
        
        self.colorView.removeFromSuperview()
        self.fontView.removeFromSuperview()
        
        let vc = PhotoController()
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.importImageClick = { assets in
            self.importImageHandle(assets: assets)
        }
        
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization() { status in
                if status == .authorized {
                    print("authorized")
                    
                    DispatchQueue.main.async {
                        
                        self.present(vc, animated: false, completion: nil)
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
            self.present(vc, animated: false, completion: nil)
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

// MARK: - 处理导入数据 图片
extension EditController {
    private func importImageHandle(assets: [PHAsset]) {
        if self.progressHud == nil {
            self.progressHud = JGProgressHUDWrapper()
        }
        
        self.progressHud?.show(self.view, completion: nil)
        
        /*
         let serialQueue = DispatchQueue(label: "label")    // 默认生成串行队列
         let concurrentQueue = DispatchQueue(label: "label", attributes: .concurrent)  //  指定则为并行队列
         */
        
        // 异步 + 串行 执行图片的获取
        for value in assets {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            PHImageManager.default().requestImage(for: value, targetSize: CGSize(width: value.pixelWidth, height: value.pixelHeight), contentMode: PHImageContentMode.default, options: options) { (image, imageInfo) in
                guard let tempData = image?.pngData() else { return }
                
                let model = StoreImgModel(insetIndex: self.textView.selectedRange.location, imgData: tempData)
                
                self.importImgLists.append(model)
            }
        }
        
        DispatchQueue.main.async {
            self.progressHud?.dismiss(nil)
            
            self.imgContainerView.isHidden = false
            
            if let firstModel = self.importImgLists.first {
                if let use = firstModel.imgData {
                    self.coverImg.image = UIImage(data: use)
                }
            }
            
            self.imgCountLbl.text = String(self.importImgLists.count)
        }
    }
    
    private func refreshTextViewStyle(style: JTFontFormat, isSet: Bool) {
        switch style {
        case .alignLeft, .alignCenter, .alignRight:
            self.textView.alignType = style
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
