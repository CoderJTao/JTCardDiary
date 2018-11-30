//
//  MusicCell.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/26.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicCell: UITableViewCell {

    @IBOutlet weak var selectImg: UIImageView!
    
    @IBOutlet weak var showImg: UIImageView!
    @IBOutlet weak var musicNameLbl: UILabel!
    @IBOutlet weak var musicSingerLbl: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    
    var playBtnCallBack: ((MPMediaItem, Bool) -> ()) = {_,_ in
        
    }
    
    var musicItem: MPMediaItem?
    
    var isChoose: Bool = false {
        didSet {
            if isChoose {
                self.selectImg.image = UIImage(named: "select_yes")
                
                /*
                 dampingRatio(动画阻尼系数)和velocity(动画开始速度)是需要重点了解的。阻尼系数（0~1），学物理的时候因该接触过，衡量阻力大小的一个标准，阻尼系数越大则说明阻力越大，动画的减速越开, 如果设为一的话，几乎没有弹簧的效果。而velocity(动画开始速度：0～1)想对来说比较好理解，就是弹簧动画开始时的速度。
                 ---------------------
                 */
                self.selectImg.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    self.selectImg.transform = CGAffineTransform.identity
                }) { (finished) in
                    
                }
            } else {
                self.selectImg.image = UIImage(named: "select_gray")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(item: MPMediaItem) {
        self.musicItem = item
        
        if let show = self.musicItem?.artwork?.image(at: CGSize(width: 100, height: 100)) {
            self.showImg.image = show
        }
        
        if let songTitle = self.musicItem?.value(forProperty: MPMediaItemPropertyTitle) as? String {
            self.musicNameLbl.text = songTitle
        }
        
        if let songArt = self.musicItem?.value(forProperty: MPMediaItemPropertyArtist) as? String {
            self.musicSingerLbl.text = songArt
        }
    }
    
    @IBAction func playBtnClick(_ sender: UIButton) {
        guard let item = self.musicItem else {
            return
        }
        
        self.playBtnCallBack(item, sender.isSelected)
    }
}
