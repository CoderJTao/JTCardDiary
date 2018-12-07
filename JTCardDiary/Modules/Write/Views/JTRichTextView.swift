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
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5  // 字体的行间距
        let attributes = [NSAttributedString.Key.font: TextFont,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle,
                          NSAttributedString.Key.foregroundColor: TextColor]
        
        self.typingAttributes = attributes
    }
    
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
            setOrderList(isSet: isListOL)
        }
    }
    
    /**无序列表*/
    var isListUL = false {
        didSet {
            setUnorderedList(isSet: isListUL)
        }
    }
    
    /// 更改样式
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
    
    //
    ///插入文字
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
    
    ///插入图片 -- 撑满一行
    func insertImage(image: UIImage, isFull: Bool = false) {
        //获取textView的所有文本，转成可变的文本
        let mutableStr = NSMutableAttributedString(attributedString: self.attributedText)
        
        //创建图片附件
        let imgAttachment = NSTextAttachment(data: nil, ofType: nil)
        var imgAttachmentString: NSMutableAttributedString
        imgAttachment.image = image
        
        //设置图片显示方式
        
        if isFull {
            //撑满一行
            let imageWidth = kScreenWidth-16
            let imageHeight = image.size.height/image.size.width*imageWidth
            imgAttachment.bounds = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        } else {
            let imageWidth = 50
            let imageHeight = 25
            imgAttachment.bounds = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        }
        
        imgAttachmentString = NSMutableAttributedString(attachment: imgAttachment)
        
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
    
    /// 插入分割线
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
    
    /// 设置有序列表
    private func setOrderList(isSet: Bool) {
        
        
    }
    
    /// 设置无序列表
    private func setUnorderedList(isSet: Bool) {
        
        
    }
}


// MARK: - 获取指定位置的文字
extension JTRichTextView {
    private func getShouldConfigStr() -> [String: Any] {
        var result = NSAttributedString(string: "")
        
        var dic: [String: Any] = [:]
        
        let beforeInfo = getCurrentLine_beforeStr()
        let behindInfo = getCurrent_lastStr()
        
        guard let begforeStr = beforeInfo["content"] as? NSAttributedString, let behindStr = behindInfo["content"] as? NSAttributedString,
              let beforIndex = beforeInfo["startIndex"] as? Int, let _ = behindInfo["startIndex"] as? Int else {
            return dic
        }
        
        let str = NSMutableAttributedString(attributedString: begforeStr)
        str.insert(behindStr, at: begforeStr.length)
        
        result = NSAttributedString(attributedString: str)
        
        dic["content"] = result
        dic["startIndex"] = beforIndex
        
        return dic
    }
    
    // MARK: -  获取当前行 选中位置前面所有字符串
    private func getCurrentLine_beforeStr() -> [String: Any] {
        if self.contentSize.height < 40 {
            return ["content": self.attributedText.attributedSubstring(from: NSRange(location: 0, length: self.selectedRange.location)), "startIndex": 0]
        }
        
        var result = NSAttributedString(string: "")
        var dic: [String: Any] = [:]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5  // 字体的行间距
        let attributes = [NSAttributedString.Key.font: TextFont,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle,
                          NSAttributedString.Key.foregroundColor: TextColor]
        
        let configStr = self.attributedText.attributedSubstring(from: NSRange(location: 0, length: self.selectedRange.location))
        
        let tempTV1 = UITextView(frame: self.bounds)
        tempTV1.typingAttributes = attributes
        tempTV1.selectedRange = NSRange(location: 0, length: self.selectedRange.location)
        tempTV1.attributedText = configStr
        
        let currentHeight = tempTV1.contentSize.height  //记录当前文字下的高度
        
        let sss = NSString(string: configStr.string)
        
        for index in 0..<sss.length {
            let newRange = NSRange(location: 0, length: self.selectedRange.location - index)
            
            tempTV1.attributedText = tempTV1.attributedText.attributedSubstring(from: newRange)
            
            if tempTV1.contentSize.height == currentHeight {
                continue
            } else {
                let resultRange = NSRange(location: newRange.length, length: self.selectedRange.location - newRange.length)
                result = configStr.attributedSubstring(from: resultRange)
                
                dic["content"] = result
                dic["startIndex"] = resultRange.location
                
                break
            }
        }
        
        return dic
    }
    
    // MARK: - 获取当前行选中位置 至后续第一个换行符的所有文字（若无换行符，则为选中位置之后的所有文字）
    private func getCurrent_lastStr() -> [String: Any] {
        if self.selectedRange.location >= self.attributedText.length {
            return ["content": NSAttributedString(string: ""), "startIndex": self.selectedRange.location]
        }
        
        var result = NSAttributedString(string: "")
        
        var dic: [String: Any] = [:]
        
        let range = self.selectedRange
        
        // 判断后面文字是否有换行  找到选中行到换行之间的文字
        let lastStr = self.attributedText.attributedSubstring(from: NSRange(location: range.location, length: self.attributedText.length - range.location))
        
        var deadLine: Int = 0
        
        for index in 0..<lastStr.length {
            let newRange = NSRange(location: index, length: 1)
            let getStr = lastStr.attributedSubstring(from: newRange)
            
            deadLine = index + 1
            
            if getStr.string == "\n" {
                deadLine = index
                break
            }
        }
        
        let resultRange = NSRange(location: 0, length: deadLine)
        
        // 选中位置 后面应该配置上列表属性的字符串
        result = lastStr.attributedSubstring(from: resultRange)
        
        dic["content"] = result
        dic["startIndex"] = range.location
        
        return dic
    }
    
    // MARK: - 获取选中行所有文字
    private func getCurrentLineText() -> [String: Any] {
        if self.contentSize.height < 40 {
            return ["content": self.attributedText, "startIndex": 0]
        }
        
        var result = NSAttributedString(string: "")
        
        var dic: [String: Any] = [:]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5  // 字体的行间距
        let attributes = [NSAttributedString.Key.font: TextFont,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle,
                          NSAttributedString.Key.foregroundColor: TextColor]
        
        let configStr = self.attributedText.attributedSubstring(from: NSRange(location: 0, length: self.selectedRange.location))
        
        let tempTV1 = UITextView(frame: self.bounds)
        tempTV1.typingAttributes = attributes
        tempTV1.selectedRange = NSRange(location: 0, length: self.selectedRange.location)
        tempTV1.attributedText = configStr
        
        let tempTV2 = UITextView(frame: self.bounds)
        tempTV2.typingAttributes = attributes
        tempTV2.selectedRange = NSRange(location: 0, length: self.selectedRange.location)
        tempTV2.attributedText = self.attributedText
        
        let currentHeight = tempTV1.contentSize.height  //记录当前文字下的高度
        
        var before = NSAttributedString(string: "")
        
        for index in 0..<configStr.length {
            let newRange = NSRange(location: 0, length: self.selectedRange.location - index)
            
            tempTV1.attributedText = tempTV1.attributedText.attributedSubstring(from: newRange)
            
            if tempTV1.contentSize.height == currentHeight {
                continue
            } else {
                let resultRange = NSRange(location: newRange.length, length: self.selectedRange.location - newRange.length)
                before = configStr.attributedSubstring(from: resultRange)
                
                dic["startIndex"] = resultRange.location
                break
            }
        }
        
        var last = NSAttributedString(string: "")
        
        if self.selectedRange.location < self.attributedText.length {
            for index in self.selectedRange.location..<self.attributedText.length {
                let newRange = NSRange(location: 0, length: index)
                
                tempTV2.attributedText = self.attributedText.attributedSubstring(from: newRange)
                
                let resultRange = NSRange(location: self.selectedRange.location, length: index-self.selectedRange.location)
                last = self.attributedText.attributedSubstring(from: resultRange)
                
                if tempTV2.contentSize.height != currentHeight {
                    break
                }
            }
        }
        
        let str = NSMutableAttributedString(attributedString: before)
        str.insert(last, at: before.length)
        
        result = NSAttributedString(attributedString: str)
        
        dic["content"] = result
        
        return dic
    }
}
