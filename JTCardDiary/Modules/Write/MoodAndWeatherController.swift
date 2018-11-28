//
//  MoodAndWeatherController.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/26.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

class MoodAndWeatherController: UIViewController {
    
    private let WEATHER_TAG: Int = 101
    private let MOOD_TAG: Int = 201
    private let WeatherArr = ["晴天", "阴天", "刮风", "小雨", "大雨", "阵雨", "雪", "雾"]
    private let MoodArr = ["开心", "无聊", "非常高兴", "酷炫", "疑问", "难过", "悲伤", "愤怒"]
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var weatherLbl: UILabel!
    @IBOutlet weak var moodLbl: UILabel!
    
    private var weatherChoose: String = ""
    private var moodChoose: String = ""
    
    var passWeatherAndMood: (String, String) -> () = {_,_ in
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.containerView.transform = CGAffineTransform(translationX: 0, y: kScreenHeight-100)
        
        UIView.animate(withDuration: 0.3) {
            self.containerView.transform = CGAffineTransform.identity
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<8 {
            let weatherBtn = self.view.viewWithTag(WEATHER_TAG+index) as! UIButton
            let moodBtn = self.view.viewWithTag(MOOD_TAG+index) as! UIButton
            
            weatherBtn.addTarget(self, action: #selector(weatherBtnClick(_:)), for: .touchUpInside)
            moodBtn.addTarget(self, action: #selector(moodBtnClick(_:)), for: .touchUpInside)
        }
        
    }
    
    func setShowImg(weather: String, mood: String) {
        if weather.isEmpty {
            self.weatherLbl?.text = "今天天气如何？"
        } else {
            if WeatherArr.contains(weather) {
                let index = WeatherArr.index(of: weather)
                if let use = index {
                    let weatherBtn = self.view.viewWithTag(WEATHER_TAG+use) as! UIButton
                    weatherBtn.isSelected = true
                    
                    self.weatherLbl?.text = weather
                }
            }
        }
        
        if mood.isEmpty {
            self.moodLbl?.text = "今天心情如何？"
        } else {
            if MoodArr.contains(mood) {
                let index = MoodArr.index(of: mood)
                if let use = index {
                    let moodBtn = self.view.viewWithTag(MOOD_TAG+use) as! UIButton
                    moodBtn.isSelected = true
                    
                    self.moodLbl?.text = mood
                }
            }
        }
    }
    
    
    @objc func weatherBtnClick(_ sender: UIButton) {
        if sender.isSelected { return }
        for index in 0..<8 {
            let weatherBtn = self.view.viewWithTag(WEATHER_TAG+index) as! UIButton
            
            weatherBtn.isSelected = false
        }
        sender.isSelected = true
        
        self.weatherChoose = WeatherArr[sender.tag - WEATHER_TAG]
        
        self.weatherLbl.text = self.weatherChoose
    }
    
    @objc func moodBtnClick(_ sender: UIButton) {
        if sender.isSelected { return }
        for index in 0..<8 {
            let moodBtn = self.view.viewWithTag(MOOD_TAG+index) as! UIButton
            
            moodBtn.isSelected = false
        }
        sender.isSelected = true
        
        self.moodChoose = MoodArr[sender.tag - MOOD_TAG]
        
        self.moodLbl.text = self.moodChoose
    }
    
    
    @IBAction func dismissClick(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: kScreenHeight-100)
        }) { (finished) in
            self.passWeatherAndMood(self.weatherChoose, self.moodChoose)
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
}
