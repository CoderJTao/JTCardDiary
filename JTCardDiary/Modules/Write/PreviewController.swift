//
//  PreviewController.swift
//  JTCardDiary
//
//  Created by JiangT on 2018/12/5.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

class PreviewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var isChangeSource = false
    private var imagesData: [StoreImgModel] = []
    
    private var scrollView = UIScrollView()
    
    var imagesChanged: ([StoreImgModel]) -> () = { _ in
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    private func setUpUI() {
        // 滚动视图
        scrollView = UIScrollView(frame: self.containerView.bounds)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.contentOffset = CGPoint.zero
        scrollView.delegate = self
        
        for (index, value) in imagesData.enumerated() {
            let imageV = UIImageView(frame: CGRect(x: self.containerView.width * CGFloat(index), y: 0, width: self.containerView.width, height: self.containerView.height))
            imageV.image = UIImage(data: value.imgData)
            imageV.contentMode = UIView.ContentMode.scaleAspectFit
            scrollView.addSubview(imageV)
        }
        
        scrollView.contentSize = CGSize(width: self.containerView.width * CGFloat(imagesData.count), height: self.containerView.height)
        
        self.containerView.addSubview(scrollView)
        
        // page control
        self.pageControl.numberOfPages = self.imagesData.count
        self.pageControl.currentPage = 0
    }
    
    func setSources(images: [StoreImgModel]) {
        self.imagesData = images
    }
    
    
    @IBAction func cancelClick(_ sender: UIButton) {
        self.imagesChanged(self.imagesData)
        self.dismiss(animated: false) {
            
        }
    }
    
    @IBAction func deleteClick(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: "删除这张照片？", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "删除", style: .destructive, handler: { (act) in
            self.isChangeSource = true
            
            self.imagesData.remove(at: self.pageControl.currentPage)
            
            for value in self.scrollView.subviews {
                value .removeFromSuperview()
            }
            
            self.pageControl.numberOfPages = self.imagesData.count
            
            for (index, value) in self.imagesData.enumerated() {
                let imageV = UIImageView(frame: CGRect(x: self.containerView.width * CGFloat(index), y: 0, width: self.containerView.width, height: self.containerView.height))
                imageV.image = UIImage(data: value.imgData)
                imageV.contentMode = UIView.ContentMode.scaleAspectFit
                self.scrollView.addSubview(imageV)
            }
            
            self.scrollView.contentSize = CGSize(width: self.containerView.width * CGFloat(self.imagesData.count), height: self.containerView.height)
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension PreviewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        
        let index = Int(offset / self.view.width)
        
        if index < 0 || index > (self.imagesData.count - 1) { return }
        
        self.pageControl.currentPage = index
    }
    
}
