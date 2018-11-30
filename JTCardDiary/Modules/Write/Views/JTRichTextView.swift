//
//  JTRichTextView.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/29.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import CoreText

class JTRichTextView: UITextView {
    
    private let TextFont = UIFont.systemFont(ofSize: 15)
    private let TextColor = UIColor.hexString(hexString: TextColor_black)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5  // 字体的行间距
        let attributes = [NSAttributedString.Key.font: TextFont,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle,
                          NSAttributedString.Key.foregroundColor: TextColor]
        
        self.typingAttributes = attributes
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**字体颜色*/
    var color = UIColor.hexString(hexString: TextColor_black) {
        didSet {
            changeStyle()
        }
    }
    
    /**对齐方式  左对齐 居中  右对齐 */
    var alignType = JTFontFormat.alignLeft {
        didSet {
            //获取textView的所有文本，转成可变的文本
            let mutableStr = NSMutableAttributedString(attributedString: self.attributedText)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5  // 字体的行间距
            
            var align = NSTextAlignment.left
            if self.alignType == .alignRight {
                align = NSTextAlignment.right
            } else if self.alignType == .alignCenter {
                align = NSTextAlignment.center
            } else {
                align = NSTextAlignment.left
            }
            
            paragraphStyle.alignment = align
            
            mutableStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: mutableStr.length))
            
            self.attributedText = mutableStr
        }
    }
    
    /**缩进*/
    var isIndent = false
    
    
    /**加分割线*/
    var addDividerLine = false {
        didSet {
            insertSeparatLine()
        }
    }
    
    /**加粗*/
    var isBold = false {
        didSet {
            changeStyle()
        }
    }
    /**斜体*/
    var isOblique = false {
        didSet {
            changeStyle()
        }
    }
    /**下划线*/
    var isUnderline = false{
        didSet {
            changeStyle()
        }
    }
    
    /**贯穿线*/
    var isThrough = false {
        didSet {
            changeStyle()
        }
    }
    
    /**有序列表*/
    var isListOL = false {
        didSet {
            
        }
    }
    
    /**无序列表*/
    var isListUL = false {
        didSet {
            
        }
    }
    
    private func changeStyle() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5  // 字体的行间距
        
        var align = NSTextAlignment.left
        if self.alignType == .alignRight {
            align = NSTextAlignment.right
        } else if self.alignType == .alignCenter {
            align = NSTextAlignment.center
        } else {
            align = NSTextAlignment.left
        }
        
        paragraphStyle.alignment = align
        
        let attributes = [NSAttributedString.Key.font: TextFont,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle,
                          NSAttributedString.Key.foregroundColor: self.color,
                          NSAttributedString.Key.strokeWidth: (isBold ? -3 : 0),
                          NSAttributedString.Key.obliqueness: (isOblique ? 0.3 : 0),
                          NSAttributedString.Key.underlineStyle: (isUnderline ? 1 : 0),
                          NSAttributedString.Key.underlineColor: self.color,
                          NSAttributedString.Key.strikethroughStyle: (isThrough ? 1 : 0),
                          NSAttributedString.Key.strikethroughColor: UIColor.hexString(hexString: TextColor_black)
                          ] as [NSAttributedString.Key : Any]
        
        self.typingAttributes = attributes
    }
    
    
    /**插入图片*/
    func insertImage(image: UIImage) {
        //获取textView的所有文本，转成可变的文本
        let mutableStr = NSMutableAttributedString(attributedString: self.attributedText)
        
        //创建图片附件
        let imgAttachment = NSTextAttachment(data: nil, ofType: nil)
        var imgAttachmentString: NSAttributedString
        imgAttachment.image = image
        
        //设置图片显示方式
        
        //撑满一行
        let imageWidth = kScreenWidth-16
        let imageHeight = image.size.height/image.size.width*imageWidth
        imgAttachment.bounds = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        
        imgAttachmentString = NSAttributedString(attachment: imgAttachment)
        
        //获得目前光标的位置
        let selectedRange = self.selectedRange
        //插入文字
        mutableStr.insert(imgAttachmentString, at: selectedRange.location)
        //设置可变文本的字体属性
        mutableStr.addAttribute(NSAttributedString.Key.font, value: TextFont,
                                range: NSMakeRange(0,mutableStr.length))
        //再次记住新的光标的位置
        let newSelectedRange = NSMakeRange(selectedRange.location+1, 0)
        
        //重新给文本赋值
        self.attributedText = mutableStr
        //恢复光标的位置（上面一句代码执行之后，光标会移到最后面）
        self.selectedRange = newSelectedRange
        //移动滚动条（确保光标在可视区域内）
        self.scrollRangeToVisible(newSelectedRange)
        
        self.nextLine()
    }
    
    //
    //插入文字
    func nextLine() {
        //获取textView的所有文本，转成可变的文本
        let mutableStr = NSMutableAttributedString(attributedString: self.attributedText)
        //获得目前光标的位置
        let selectedRange = self.selectedRange
        //插入文字
        let attStr = NSAttributedString(string: "\n")
        mutableStr.insert(attStr, at: selectedRange.location)
        
        //设置可变文本的字体属性
        mutableStr.addAttribute(NSAttributedString.Key.font, value: TextFont,
                                range: NSMakeRange(0,mutableStr.length))
        // color
        mutableStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hexString(hexString: "TextColor_gray"),
                                range: NSMakeRange(0,mutableStr.length))
        // 行间距
        let para = NSMutableParagraphStyle.init()
        para.lineSpacing = 5
        mutableStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: para,
                                range: NSMakeRange(0,mutableStr.length))
        
        //再次记住新的光标的位置
        let newSelectedRange = NSMakeRange(selectedRange.location + attStr.length, 0)
        
        //重新给文本赋值
        self.attributedText = mutableStr
        //恢复光标的位置（上面一句代码执行之后，光标会移到最后面）
        self.selectedRange = newSelectedRange
    }
    
    func getCurrentLine(text: String) {
        
    }
    
    
    private func  insertSeparatLine() {
        //获取textView的所有文本，转成可变的文本
        let mutableStr = NSMutableAttributedString(attributedString: self.attributedText)
        
        //创建图片附件
        let imgAttachment = NSTextAttachment(data: nil, ofType: nil)
        var imgAttachmentString: NSAttributedString
        
        let image = UIImage(named: "sepLine")
        imgAttachment.image = image
        //设置图片显示方式
        
        //撑满一行
        let imageWidth = self.width - 16
        imgAttachment.bounds = CGRect(x: 8, y: 0, width: imageWidth, height: 16)
        
        imgAttachmentString = NSAttributedString(attachment: imgAttachment)
        
        //获得目前光标的位置
        let selectedRange = self.selectedRange
        //插入文字
        mutableStr.insert(imgAttachmentString, at: selectedRange.location)
        //设置可变文本的字体属性
        mutableStr.addAttribute(NSAttributedString.Key.font, value: TextFont,
                                range: NSMakeRange(0,mutableStr.length))
        //再次记住新的光标的位置
        let newSelectedRange = NSMakeRange(selectedRange.location+1, 0)
        
        //重新给文本赋值
        self.attributedText = mutableStr
        //恢复光标的位置（上面一句代码执行之后，光标会移到最后面）
        self.selectedRange = newSelectedRange
        //移动滚动条（确保光标在可视区域内）
        self.scrollRangeToVisible(newSelectedRange)
        
        self.nextLine()
    }
    
}

