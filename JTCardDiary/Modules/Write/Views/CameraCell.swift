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
                
                let pulse = CASpringAnimation(keyPath: "transform.scale")
                pulse.damping = 7.5 //阻尼，调整动画到达稳定时间的值，默认值为10.0。阻尼值越大，动画持续时间远短。可以是任何的自然数，如果为0，将永远震荡下去。
                pulse.fromValue = 0.8
                pulse.toValue = 1.0
                pulse.initialVelocity = 0 //初始速度，默认值为0.0，可以是一切整数
                pulse.mass = 0.8 // 重量，类似于锤摆的重量，默认值为1.0。
                pulse.stiffness = 100 //弹性系数，默认值为100.0。值越小，弹跳的越柔软，值越大，弹跳的越僵硬。
                pulse.duration = pulse.settlingDuration
                self.chooseImg.layer.add(pulse, forKey: nil)
                
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
