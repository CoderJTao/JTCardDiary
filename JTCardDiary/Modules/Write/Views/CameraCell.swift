//
//  CameraCell.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/22.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import Photos

class CameraCell: UICollectionViewCell {
    
    private var player = AVPlayer()
    private var playerLayer = AVPlayerLayer()
    
    private lazy var showImg: UIImageView = {
        let imageV = UIImageView(frame: self.bounds)
        imageV.contentMode = UIView.ContentMode.scaleAspectFill
        imageV.layer.masksToBounds = true
        return imageV
    }()
    
    var isChoose: Bool = false {
        didSet {
            if isChoose {
                self.chooseImg.image = UIImage(named: "select_yes")
                
                /*
                 dampingRatio(动画阻尼系数)和velocity(动画开始速度)是需要重点了解的。阻尼系数（0~1），学物理的时候因该接触过，衡量阻力大小的一个标准，阻尼系数越大则说明阻力越大，动画的减速越开, 如果设为一的话，几乎没有弹簧的效果。而velocity(动画开始速度：0～1)想对来说比较好理解，就是弹簧动画开始时的速度。
                 ---------------------
                 */
                self.chooseImg.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    self.chooseImg.transform = CGAffineTransform.identity
                }) { (finished) in
                    
                }
            } else {
                self.chooseImg.image = UIImage(named: "select_no")
            }
            
        }
    }
    
    private lazy var chooseImg: UIImageView = {
        let img = UIImageView(frame: CGRect(x: self.width-30, y: 6, width: 24, height: 24))
        img.image = UIImage(named: "select_no")
        return img
    }()
    
    private let imageManager = PHImageManager.default()
    
    var _asset: PHAsset?
    var _playItem: AVPlayerItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(showImg)
        addSubview(chooseImg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAsset(asset: PHAsset, type: PHAssetMediaType) {
        if type == .image {
            self._asset = asset
            self.chooseImg.isHidden = false
            
            imageManager.requestImage(for: asset, targetSize: CGSize(width: self.width*UIScreen.main.scale, height: self.height*UIScreen.main.scale), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, imageDic) in
                guard let temp = image else { return }
                
                self.showImg.image = temp
            }
            
        } else {
            // options 待定
            imageManager.requestPlayerItem(forVideo: asset, options: nil) { (playItem, info) in
                self._playItem = playItem
                DispatchQueue.main.async {
                    self.player = AVPlayer(playerItem: playItem)
                    self.playerLayer = AVPlayerLayer(player: self.player)
                    self.playerLayer.backgroundColor = UIColor.black.cgColor
                    self.playerLayer.frame = self.bounds
                    self.layer.addSublayer(self.playerLayer)
                }
            }
        }
    }
    
    func setAddImage() {
        self.chooseImg.isHidden = true
        self.showImg.image = UIImage(named: "photo_add")
    }
    
    
    
    
    
}
