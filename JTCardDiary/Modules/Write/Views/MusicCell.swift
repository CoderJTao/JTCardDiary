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
            self.selectImg.image = isChoose ? UIImage(named: "select_yes") : UIImage(named: "select_no")
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
