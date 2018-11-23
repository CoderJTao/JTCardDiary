//
//  MusicController.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/23.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initData()
    }

    
    private func initData() {
        //从ipod库中读出音乐文件
        let everything =  MPMediaQuery()
        let itemsFromGenericQuery = everything.items
        for song in itemsFromGenericQuery! {
            //获取音乐名称
            let songTitle = song.value(forProperty: MPMediaItemPropertyTitle)
            print("songTitle==\(songTitle)")
            //获取作者名称
            let songArt = song.value(forProperty: MPMediaItemPropertyArtist)
            print("songArt=\(songArt)")
            //获取音乐路径
            let songUrl = song.value(forProperty: MPMediaItemPropertyAssetURL)
            print("songUrl==\(songUrl)")
        }
    }
}
