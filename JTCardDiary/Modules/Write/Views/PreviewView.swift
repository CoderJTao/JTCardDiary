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
    
    private var imageArr: [UIImage] = []
    
    private var progressHud: JGProgressHUDWrapper?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSources(sources: [PHAsset]) {
        imageArr.removeAll()
        
        if self.progressHud == nil {
            self.progressHud = JGProgressHUDWrapper()
        }
        
        self.progressHud?.show(self, completion: nil)
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        for value in sources {
            PHImageManager.default().requestImage(for: value, targetSize: CGSize(width: value.pixelWidth, height: value.pixelHeight), contentMode: PHImageContentMode.default, options: options) { (image, imageInfo) in
                guard let temp = image else { return }
                
                self.imageArr.append(temp)
            }
        }
        
         self.setUpUI()
    }
    
    private func setUpUI() {
        
        self.progressHud?.dismiss(nil)
        
        // 滚动视图
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.contentOffset = CGPoint.zero
        //        scrollView.delegate = self
        
        for (index, value) in self.imageArr.enumerated() {
            let imageV = UIImageView(frame: CGRect(x: self.width * CGFloat(index), y: 0, width: self.width, height: self.height))
            imageV.image = value
            imageV.contentMode = UIView.ContentMode.scaleAspectFit
            scrollView.addSubview(imageV)
        }
        
        scrollView.contentSize = CGSize(width: self.width * CGFloat(imageArr.count), height: 0)
        
        self.addSubview(scrollView)
    }
    
}
