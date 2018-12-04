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
    
    var player = AVPlayer()
    private var playerLayer = AVPlayerLayer()
    
    private lazy var showImg: UIImageView = {
        let imageV = UIImageView(frame: self.bounds)
        imageV.contentMode = UIView.ContentMode.scaleAspectFill
        imageV.layer.masksToBounds = true
        return imageV
    }()
    
    private lazy var videoImg: UIImageView = {
        let imageV = UIImageView(frame: CGRect(x: 4, y: self.height-17, width: 18, height: 15))
        imageV.image = UIImage(named: "video_white")
        
        return imageV
    }()
    
    private lazy var videoDurationLbl: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 26, y: self.height-17, width: self.width - 30, height: 15))
        lbl.textAlignment = .right
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = UIColor.white
        return lbl
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
    
    var _imageAsset: PHAsset?
    
    var _videoAsset: AVAsset?
    var _videoPreviewImage: UIImage?
    
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
            self._imageAsset = asset
            self.chooseImg.isHidden = false
            
            imageManager.requestImage(for: asset, targetSize: CGSize(width: self.width*UIScreen.main.scale, height: self.height*UIScreen.main.scale), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, imageDic) in
                guard let temp = image else { return }
                
                self.showImg.image = temp
            }
            
        } else {
            addSubview(self.videoImg)
            addSubview(self.videoDurationLbl)
            
            imageManager.requestAVAsset(forVideo: asset, options: nil) { (avAsset, audioMix, info) in
                guard let useAsset = avAsset else { return }
                
                self._videoAsset = useAsset
                
                let duration = CMTimeGetSeconds(useAsset.duration)
                
                let assetGen = AVAssetImageGenerator(asset: useAsset)
                
                assetGen.appliesPreferredTrackTransform = true
                
                let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
                
                let image = try? assetGen.copyCGImage(at: time, actualTime: nil)
                if let useImgae = image {
                    
                    let videoImage = UIImage(cgImage: useImgae)
                    
                    self._videoPreviewImage = UIImage(cgImage: useImgae)
                    
                    DispatchQueue.main.async {
                        self.showImg.image = videoImage
                        self.videoDurationLbl.text = self.getFormatPlayTime(secounds: duration)
                    }
                    
                }
            }
        }
    }
    
    func setAddImage() {
        self.chooseImg.isHidden = true
        self.showImg.image = UIImage(named: "photo_add")
    }
    
    
    func getFormatPlayTime(secounds: Double)->String{
        if secounds.isNaN{
            return "00:00"
        }
        var Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        var Hour = 0
        if Min>=60 {
            Hour = Int(Min / 60)
            Min = Min - Hour*60
            return String(format: ":%02d:%02d", Min, Sec)
        }
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    
}
