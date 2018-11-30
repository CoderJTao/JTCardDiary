//
//  PhotoController.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/23.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import Photos

class PhotoController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var functionView: UIView!
    @IBOutlet weak var previewBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    private var type: MediaType = .image
    
    private var preView: PreviewView?
    
    private var thumbnailImageSize: CGSize {
        get {
            return CGSize(width: ((kScreenWidth - 20) / 4), height: ((kScreenWidth - 20) / 4))
        }
    }
    
    private var results: PHFetchResult<PHAsset>!
    private var selectAsset: [PHAsset] = []
    private var selectPlayItem: AVPlayerItem?
    
    var importImageClick: ([PHAsset])->() = { _ in
        
    }
    
    var importVideoClick: (AVPlayerItem)->() = { _ in
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func setType(type: MediaType) {
        self.type = type
    }
    
    @objc func dismissClick() {
        if let vw = self.preView {
            UIView.animate(withDuration: 0.3, animations: {
                vw.frame = CGRect(x: self.view.width, y: self.collectionView.originY, width: self.view.width, height: self.view.height-self.collectionView.originY)
            }) { (finished) in
                vw.removeFromSuperview()
                self.preView = nil
            }
        } else {
            self.dismiss(animated: true) {
                
            }
        }
    }
    
    private func initData() {
        //则获取所有资源
        let allPhotosOptions = PHFetchOptions()
        //按照创建时间倒序排列
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                             ascending: false)]
        
        allPhotosOptions.fetchLimit = 40
        
        if self.type == .image {
            //只获取图片""
            allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            self.results = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: allPhotosOptions)
        } else {
            allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
            self.results = PHAsset.fetchAssets(with: PHAssetMediaType.video, options: allPhotosOptions)
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    

    @IBAction func previewBtnClick(_ sender: UIButton) {
        if self.selectAsset.count <= 0 { return }
        
        if self.preView != nil {
            self.preView = nil
        }
        
        preView = PreviewView(frame: CGRect(x: self.view.width, y: self.collectionView.originY, width: self.view.width, height: self.view.height-self.collectionView.originY))
        preView?.backgroundColor = UIColor.hexString(hexString: "404040")
        
        self.view.addSubview(preView!)
        
        UIView.animate(withDuration: 0.3) {
            self.preView?.frame = CGRect(x: 0, y: self.collectionView.originY, width: self.view.width, height: self.view.height-self.collectionView.originY)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.preView?.frame = CGRect(x: 0, y: self.collectionView.originY, width: self.view.width, height: self.view.height-self.collectionView.originY)
        }) { (finished) in
            self.preView?.setSources(sources: self.selectAsset)
        }
    }
    
    
    @IBAction func confirmBtnClick(_ sender: UIButton) {
        if self.type == .image {
            if self.selectAsset.count <= 0 { return }
            
            self.importImageClick(self.selectAsset)
        } else {
            guard let item = self.selectPlayItem else { return }
            
            self.importVideoClick(item)
        }
        
        self.dismissClick()
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
        
        self.title = "照片"
        self.functionView.addLine(positon: .top)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(dismissClick))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.hexString(hexString: "2D2D2D")
    }
    
    
}

extension PhotoController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sources = self.results else {
            if self.type == .image {
                return 1
            } else {
                return 0
            }
        }
        
        if self.type == .image {
            return sources.count + 1
        } else {
            return sources.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CameraCell", for: indexPath) as! CameraCell
        
        guard let sources = self.results else {
            if self.type == .image {
                cell.setAddImage()
            }
            return cell
        }
        
        if sources.count - 1 >= indexPath.row {
            cell.setAsset(asset: sources.object(at: indexPath.row), type: self.type == .image ? PHAssetMediaType.image : PHAssetMediaType.video)
        } else {
            if self.type == .image {
                cell.setAddImage()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CameraCell
        
        guard let sources = self.results else {
            if self.type == .image {
                // 拍照
                print("拍照")
            }
            return
        }
        
        cell.isChoose = !cell.isChoose
        
        if self.type == .image {
            if sources.count - 1 >= indexPath.row {
                if cell.isChoose {
                    // 选中照片
                    if let useAsset = cell._asset {
                        if !self.selectAsset.contains(useAsset) {
                            self.selectAsset.append(useAsset)
                        }
                    }
                    self.previewBtn.isEnabled = true
                    self.confirmBtn.isEnabled = true
                    
                    self.confirmBtn.setTitle("导入"+"("+"\(self.selectAsset.count)"+")", for: .normal)
                } else {
                    // 取消选中
                    if let useAsset = cell._asset {
                        if self.selectAsset.contains(useAsset) {
                            self.selectAsset = self.selectAsset.filter {
                                $0.burstIdentifier != useAsset.burstIdentifier
                            }
                        }
                    }
                    
                    if self.selectAsset.count > 0 {
                        self.confirmBtn.setTitle("导入"+"("+"\(self.selectAsset.count)"+")", for: .normal)
                        self.previewBtn.isEnabled = true
                        self.confirmBtn.isEnabled = true
                    } else {
                        self.confirmBtn.setTitle("导入", for: .normal)
                        self.previewBtn.isEnabled = false
                        self.confirmBtn.isEnabled = false
                    }
                }
                
            } else {
                // 拍照
                print("拍照")
            }
        } else {
            if cell.isChoose {
                // 选中视频
                if self.selectPlayItem != nil {
                    let hud = JGProgressHUDWrapper.init()
                    hud.content = "只能导入一个视频"
                    hud.show(self.view) {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 1), execute: {
                            hud.dismiss(nil)
                        })
                    }
                    return
                }
                if let useItem = cell._playItem {
                    self.selectPlayItem = useItem
                }
                
                self.confirmBtn.setTitle("导入"+"(1)", for: .normal)
            } else {
                // 取消选中
                self.selectPlayItem = nil
                
                self.confirmBtn.setTitle("导入", for: .normal)
            }
        }
    }
}













enum MediaType {
    case image
    case video
}
