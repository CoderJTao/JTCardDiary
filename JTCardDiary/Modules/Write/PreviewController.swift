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
    
    private var imagesData: [StoreImgModel] = []
    
    private var scrollView = UIScrollView()
    
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
        self.dismiss(animated: false) {
            
        }
    }
    
    @IBAction func deleteClick(_ sender: UIButton) {
        self.imagesData.remove(at: pageControl.currentPage)
        
        
        for value in self.scrollView.subviews {
            value .removeFromSuperview()
        }
        
        self.pageControl.numberOfPages = imagesData.count
        
        for (index, value) in imagesData.enumerated() {
            let imageV = UIImageView(frame: CGRect(x: self.containerView.width * CGFloat(index), y: 0, width: self.containerView.width, height: self.containerView.height))
            imageV.image = UIImage(data: value.imgData)
            imageV.contentMode = UIView.ContentMode.scaleAspectFit
            scrollView.addSubview(imageV)
        }
        
        scrollView.contentSize = CGSize(width: self.containerView.width * CGFloat(imagesData.count), height: self.containerView.height)
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
