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
    
    private var musics: [MPMediaItem] = []
    private var chooseMusic: MPMediaItem?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var functionView: UIView!
    @IBOutlet weak var importBtn: UIButton!
    
    var importMusicClick: (MPMediaItem)->() = { _ in
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
        initData()
    }

    private func setUpUI() {
        self.tableView.register(UINib(nibName: "MusicCell", bundle: nil), forCellReuseIdentifier: "MusicCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.title = "音乐"
//        self.functionView.addLine(positon: .top)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(dismissClick))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.hexString(hexString: "2D2D2D")
    }
    
    @objc func dismissClick() {
        self.dismiss(animated: true) {
            
        }
    }
    
    func initData() {
        //从ipod库中读出音乐文件
        let everything =  MPMediaQuery()
        let itemsFromGenericQuery = everything.items
        
        guard let results = itemsFromGenericQuery else {
            return
        }
        
        self.musics = results
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
//        for song in itemsFromGenericQuery! {
//            //获取音乐名称
//            let songTitle = song.value(forProperty: MPMediaItemPropertyTitle) as? String
//            print("songTitle==\(songTitle)")
//            //获取作者名称
//            let songArt = song.value(forProperty: MPMediaItemPropertyArtist) as? String
//            print("songArt=\(songArt)")
//            //获取音乐路径
//            let songUrl = song.value(forProperty: MPMediaItemPropertyAssetURL) as? String
//            print("songUrl==\(songUrl)")
//        }
    }
    
    @IBAction func importBtnClick(_ sender: UIButton) {
        guard let music = self.chooseMusic else { return }
        
        self.importMusicClick(music)
        self.dismissClick()
    }
}

extension MusicController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musics.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as! MusicCell
        
        cell.playBtnCallBack = { (musicItem, isPlay) in
            if isPlay {
                print("播放当前点击按妞的音乐")
            } else {
                print("停止播放")
            }
        }
        
        cell.setItem(item: self.musics[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! MusicCell
        
        guard let item = cell.musicItem else {
            return
        }
        
        cell.isChoose = !cell.isChoose
        
        if cell.isChoose {
            if self.chooseMusic != nil {
                let hud = JGProgressHUDWrapper.init()
                hud.content = "只能导入一个音乐哦"
                hud.show(self.view) {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 1), execute: {
                        hud.dismiss(nil)
                    })
                }
                return
            }
            self.chooseMusic = item
        } else {
            self.chooseMusic = nil
        }
        
        if self.chooseMusic != nil {
            self.importBtn.setTitle("导入"+"(1)", for: .normal)
        } else {
            self.importBtn.setTitle("导入", for: .normal)
        }
    }
}
