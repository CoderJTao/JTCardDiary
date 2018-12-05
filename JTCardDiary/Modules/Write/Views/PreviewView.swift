//
//  PreviewView.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/29.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import Photos

class PreviewView: UIView {

    private var scrollView = UIScrollView()
    
    private var progressHud: JGProgressHUDWrapper?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.hexString(hexString: "404040", alpha: 0.8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSources(images: [StoreImgModel]) {
        // 滚动视图
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.contentOffset = CGPoint.zero
        //        scrollView.delegate = self
        
        for (index, value) in images.enumerated() {
            let imageV = UIImageView(frame: CGRect(x: self.width * CGFloat(index), y: 0, width: self.width, height: self.height))
            imageV.image = UIImage(data: value.imgData)
            imageV.contentMode = UIView.ContentMode.scaleAspectFit
            scrollView.addSubview(imageV)
        }
        
        scrollView.contentSize = CGSize(width: self.width * CGFloat(images.count), height: 0)
        
        self.addSubview(scrollView)
    }
    
}
