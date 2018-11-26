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
//        layout.min
        layout.scrollDirection = .vertical
        
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.collectionViewLayout = layout
        
        //初始化显示默认内容
        insertString("1、正是三月天，城外天显得极高，也极清。田野酥酥软软的，草发得十分嫩，其中有了蒲公英，一点一点的淡黄，使人心神儿几分荡漾了。远远看着杨柳，绿得有了烟雾，晕得如梦一般，禁不住近去看时，枝梢却没叶片，皮下的脉络是楚楚地流动绿。 路上行人很多，有的坐着车，或是谋事；有的挑着担，或是买卖。春光悄悄儿走来，只有他们这般儿悠闲，醺醺然。也只有他们深得这春之妙味了。 ——贾平凹《品茶》\n2、桑桑在校园里随便走走，就走到了小屋前。这时，桑桑被一股浓烈的苦艾味包围了。他的眼前是一片艾。艾前后左右地包围了小屋。当风吹过时，艾叶哗啦哗啦地翻卷着。艾叶的正面与反面的颜色是两样的，正面是一般的绿色，而反面是淡绿色，加上茸茸的细毛，几乎呈灰白色。因此，当艾叶翻卷时，就像不同颜色的碎片混杂在一起，闪闪烁烁。艾虽然长不很高，但杆都长得像毛笔的笔杆一样，不知是因为人工的原因，还是艾的习性，艾与艾之间，总是适当地保持着距离，既不过于稠密，却又不过于疏远。——草房子\n3、秃鹤的秃，是很地道的。他用长长的好看的脖子，支撑起那么一颗光溜溜的脑袋，这颗脑袋绝无一丝瘢痕，光滑得竟然那么均匀，阳光下，这颗脑袋像打了蜡一般地亮，让他的同学们无端地想起夜里，它也会亮的。由于秃成这样，孩子们就会常常出神地去看，并会在心里生出要用手指头醮了一点唾沫去轻轻摩挲它一下的欲望。——草房子\n4、他发现了人类行为的一大法则，自己还不知道——那就是，为了要使一个大人或小孩极想干某样事情，只需要设法把那件事情弄得不易到手就行了。——《汤姆·索亚历险记》\n5、“天下只有两种人。譬如一串葡萄到手，一种人挑最好的先吃，另一种人把最好的留在最后吃。照例第一种人应该乐观，因为他每吃一颗都是吃剩的葡萄里最好的；第二种应该悲观，因为他每吃一颗都是吃剩的葡萄里最坏的。不过事实上适得其反，缘故是第二种人还有希望，第一种人只有回忆。” ——钱钟书《围城》")
        insertPicture(UIImage(named: "test3")!, mode:.fitTextView)
        insertString("欢迎欢迎欢迎欢迎!欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎欢迎!")
        
    }
    
    //插入文字
    func insertString(_ text:String) {
        //获取textView的所有文本，转成可变的文本
        let mutableStr = NSMutableAttributedString(attributedString: textView.attributedText)
        //获得目前光标的位置
        let selectedRange = textView.selectedRange
        //插入文字
        let attStr = NSAttributedString(string: text)
        mutableStr.insert(attStr, at: selectedRange.location)
        
        //设置可变文本的字体属性
        mutableStr.addAttribute(NSAttributedString.Key.font, value: textFont,
                                range: NSMakeRange(0,mutableStr.length))
        // color
        mutableStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hexString(hexString: "TextColor_gray"),
                                range: NSMakeRange(0,mutableStr.length))
        // 行间距
        let para = NSMutableParagraphStyle.init()
        para.lineSpacing = 4
        mutableStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: para,
                                range: NSMakeRange(0,mutableStr.length))
        
        //再次记住新的光标的位置
        let newSelectedRange = NSMakeRange(selectedRange.location + attStr.length, 0)
        
        //重新给文本赋值
        textView.attributedText = mutableStr
        //恢复光标的位置（上面一句代码执行之后，光标会移到最后面）
        textView.selectedRange = newSelectedRange
    }
    
    //插入图片
    func insertPicture(_ image:UIImage, mode:ImageAttachmentMode = .default){
        //获取textView的所有文本，转成可变的文本
        let mutableStr = NSMutableAttributedString(attributedString: textView.attributedText)
        
        //创建图片附件
        let imgAttachment = NSTextAttachment(data: nil, ofType: nil)
        var imgAttachmentString: NSAttributedString
        imgAttachment.image = image
        
        //设置图片显示方式
        if mode == .fitTextLine {
            //与文字一样大小
            imgAttachment.bounds = CGRect(x: 0, y: -4, width: textView.font!.lineHeight,
                                          height: textView.font!.lineHeight)
        } else if mode == .fitTextView {
            //撑满一行
            let imageWidth = kScreenWidth-16
            let imageHeight = image.size.height/image.size.width*imageWidth
            imgAttachment.bounds = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        }
        
        imgAttachmentString = NSAttributedString(attachment: imgAttachment)
        
        //获得目前光标的位置
        let selectedRange = textView.selectedRange
        //插入文字
        mutableStr.insert(imgAttachmentString, at: selectedRange.location)
        //设置可变文本的字体属性
        mutableStr.addAttribute(NSAttributedString.Key.font, value: textFont,
                                range: NSMakeRange(0,mutableStr.length))
        //再次记住新的光标的位置
        let newSelectedRange = NSMakeRange(selectedRange.location+1, 0)
        
        //重新给文本赋值
        textView.attributedText = mutableStr
        //恢复光标的位置（上面一句代码执行之后，光标会移到最后面）
        textView.selectedRange = newSelectedRange
        //移动滚动条（确保光标在可视区域内）
        self.textView.scrollRangeToVisible(newSelectedRange)
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
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryListCell", for: indexPath) as! DiaryListCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DisplayController()
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
