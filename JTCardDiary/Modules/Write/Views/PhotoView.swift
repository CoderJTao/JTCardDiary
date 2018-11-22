//
//  CameraView.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/20.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import Photos

class PhotoView: UIView {
    
    private var thumbnailImageSize: CGSize {
        get {
            return CGSize(width: (kScreenWidth - 16) / 3, height: (kScreenWidth - 16) / 3)
        }
    }
    
    private var results: PHFetchResult<PHAsset>!
    private var selectAsset: [PHAsset] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var importBtn: UIButton!
    @IBOutlet weak var bottomImportBtn: NSLayoutConstraint!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    }
    
    
    
    func initData() {
        //则获取所有资源
        let allPhotosOptions = PHFetchOptions()
        //按照创建时间倒序排列
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                             ascending: false)]
        //只获取图片""
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        self.results = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: allPhotosOptions)
        
        DispatchQueue.main.async {
           self.collectionView.reloadData()
        }
        
    }
    
    @IBAction func importBtnClick(_ sender: UIButton) {
    }
}


extension PhotoView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.results.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CameraCell", for: indexPath) as! CameraCell
        
        if self.results.count - 1 >= indexPath.row {
            cell.setAsset(asset: self.results.object(at: indexPath.row), type: PHAssetMediaType.image)
        } else {
            cell.setAddImage()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CameraCell
        
        if self.results.count - 1 >= indexPath.row {
            cell.isChoose = !cell.isChoose
            
            guard let useAsset = cell._asset else {
                print("从cell取得的asset为空")
                return
            }
            if cell.isChoose {
                if !self.selectAsset.contains(useAsset) {
                    self.selectAsset.append(useAsset)
                }
            } else {
                if self.selectAsset.contains(useAsset) {
                    self.selectAsset = self.selectAsset.filter {
                        return $0.localIdentifier != useAsset.localIdentifier
                    }
                }
            }
            
            if self.selectAsset.count > 0 {
                if bottomImportBtn.constant != 0 {
                    UIView.animate(withDuration: 0.2) {
                        self.bottomImportBtn.constant = 0
                        self.layoutIfNeeded()
                    }
                }
                self.importBtn.setTitle("导入\(self.selectAsset.count)张照片", for: .normal)
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.bottomImportBtn.constant = -44
                    self.layoutIfNeeded()
                }
                self.importBtn.setTitle("导入0张照片", for: .normal)
            }
            
        } else {
            // 拍照
            
            
        }
    }
}
