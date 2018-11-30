//
//  DiaryListController.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/15.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

class DiaryListController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var listData: [DiaryModel] = []
    
    private var textView = UITextView()
    private let textFont = UIFont.systemFont(ofSize: 15, weight: .thin)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showNavigationBackButton()
        self.hideNavigationBarHairLine()
        self.setNavigationBarBackGroundColor()
        
        setUpUI()
        
        
        
    }
    
    func setTitle(title: String) {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        lbl.textAlignment = .center
        lbl.textColor = UIColor.hexString(hexString: TextColor_black)
        lbl.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        lbl.text = title
        self.navigationItem.titleView = lbl
    }
    
    @IBAction func writeTodayBtnClick(_ sender: UIButton) {
        let dateStr = Date().toString()
        
        let vc = EditController()
        vc.setDateTitle(title: dateStr)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

/*
 //转换图片
 CIContext *context = [CIContext contextWithOptions:nil];
 
 CIImage *midImage = [CIImage imageWithData:UIImagePNGRepresentation(image)];
 //图片开始处理
 CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
 [filter setValue:midImage forKey:kCIInputImageKey];
 //value 改变模糊效果值
 [filter setValue:@7.0f forKey:@"inputRadius"];
 CIImage *result = [filter valueForKey:kCIOutputImageKey];
 CGImageRef outimage = [context createCGImage:result fromRect:[result extent]];
 //转换成UIimage
 UIImage *resultImage = [UIImage imageWithCGImage:outimage];
 imageview.image = resultImage;
 */

extension DiaryListController {
    private func setUpUI() {
        self.collectionView.register(UINib(nibName: "DiaryListCell", bundle: nil), forCellWithReuseIdentifier: "DiaryListCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .vertical
        
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.collectionViewLayout = layout
    }
}

//插入的图片附件的尺寸样式
enum ImageAttachmentMode {
    case `default`  //默认（不改变大小）
    case fitTextLine  //使尺寸适应行高
    case fitTextView  //使尺寸适应textView
}

extension DiaryListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryListCell", for: indexPath) as! DiaryListCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DisplayController()
        
        let arr = self.textView.attributedText.transformToArray()
        
        vc.setDiaryModel(model: listData[indexPath.row])
//        vc.setText(text: self.textView.attributedText)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth*0.75, height: kScreenWidth*0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
}
