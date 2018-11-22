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
    private lazy var showImg: UIImageView = {
        let imageV = UIImageView(frame: self.bounds)
        
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
            
            imageManager.requestImage(for: asset, targetSize: self.bounds.size, contentMode: PHImageContentMode.aspectFill, options: nil) { (image, imageDic) in
                guard let temp = image else { return }
                
                self.showImg.image = temp
                
                print(imageDic)
            }
            
        } else {
            imageManager.requestPlayerItem(forVideo: asset, options: nil) { (playerItem, info) in
                
                print(info)
            }
        }
        
    }
    
    func setAddImage() {
        self.chooseImg.isHidden = true
        self.showImg.image = UIImage(named: "photo_add")
    }
    
    
    
    
    
}
