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
            self.chooseImg.image = isChoose ? UIImage(named: "select_yes") : UIImage(named: "select_no")
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
