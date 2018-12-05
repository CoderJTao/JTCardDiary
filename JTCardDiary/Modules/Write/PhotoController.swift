//
//  PhotoController.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/23.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import AVKit

class PhotoController: UIViewController {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var functionView: UIView!
    @IBOutlet weak var cameraBtn: UIButton!
    
    @IBOutlet weak var importBtn: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
  
    private var preView: PreviewView?
    
    private var thumbnailImageSize: CGSize {
        get {
            return CGSize(width: ((kScreenWidth - 20) / 4), height: ((kScreenWidth - 20) / 4))
        }
    }
    
    private var results: PHFetchResult<PHAsset>!
    private var selectAsset: [PHAsset] = []
    
    private var selectVideoAsset: AVAsset?
    private var videoPreviewImg: UIImage?
    
    var importImageClick: ([PHAsset])->() = { _ in
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.heightConstraint.constant = 0
        
        UIView.animate(withDuration: 0.2) {
            self.heightConstraint.constant = kScreenHeight / 2
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        initData()
        
        self.title = "照片"
    }
    
    private func initData() {
        //则获取所有资源
        let allPhotosOptions = PHFetchOptions()
        //按照创建时间倒序排列
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                             ascending: false)]
        
        allPhotosOptions.fetchLimit = 40
        
        //只获取图片""
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        self.results = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: allPhotosOptions)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func cancleClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, animations: {
            self.heightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func cameraClick(_ sender: UIButton) {
    }
    
    
    @IBAction func importBtnClick(_ sender: UIButton) {
        self.importImageClick(self.selectAsset)
        
        self.cancleClick(UIButton())
    }
}

extension PhotoController {
    private func setUpUI() {
        self.collectionView.register(CameraCell.self, forCellWithReuseIdentifier: "CameraCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = thumbnailImageSize
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        self.collectionView.showsVerticalScrollIndicator = true
        self.collectionView.collectionViewLayout = layout
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.functionView.addLine(UIColor.hexString(hexString: TextColor_gray).cgColor, positon: .bottom)
        
        self.collectionView.alwaysBounceVertical = true
    }
    
    
}

extension PhotoController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CameraCell", for: indexPath) as! CameraCell
        
        guard let sources = self.results else {
            return cell
        }
        cell.setAsset(asset: sources.object(at: indexPath.row))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CameraCell
        
        cell.isChoose = !cell.isChoose
        
        if cell.isChoose {
            // 选中照片
            if let useAsset = cell._imageAsset {
                if !self.selectAsset.contains(useAsset) {
                    self.selectAsset.append(useAsset)
                }
            }
            
        } else {
            // 取消选中
            if let useAsset = cell._imageAsset {
                if self.selectAsset.contains(useAsset) {
                    self.selectAsset = self.selectAsset.filter {
                        $0 != useAsset
                    }
                }
            }
        }
        
        self.importBtn.setTitle("导入\(self.selectAsset.count)张照片", for: .normal)
        
        if self.selectAsset.count > 0 {
            if self.bottomConstraint.constant == 0 { return }
            
            UIView.animate(withDuration: 0.2) {
                self.bottomConstraint.constant = 0
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.bottomConstraint.constant = -44
            }
        }
        self.view.layoutIfNeeded()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if heightConstraint.constant == kScreenHeight - kStatusBarHeight {
            if offsetY <= -30 {
                UIView.animate(withDuration: 0.2) {
                    self.heightConstraint.constant = kScreenHeight / 2
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        if heightConstraint.constant == kScreenHeight / 2 {
            if offsetY >= 10 {
                UIView.animate(withDuration: 0.2) {
                    self.heightConstraint.constant = kScreenHeight - kStatusBarHeight
                    self.view.layoutIfNeeded()
                }
            }
        }
        
    }
}
