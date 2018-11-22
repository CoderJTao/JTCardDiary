//
//  JTCalendarCell.swift
//  JTCalendar
//
//  Created by 江涛 on 2018/10/24.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit

class JTCalendarCell: UICollectionViewCell {
    
    lazy var daysLbl: UILabel = {
        let daysLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        daysLabel.textAlignment = .center
        daysLabel.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        daysLabel.textColor = UIColor.hexString(hexString: TextColor_black)
        return daysLabel
    }()
    
    lazy var lineLbl: UILabel = {
        let daysLabel = UILabel(frame: CGRect(x: 4, y: self.height-3, width: self.width-8, height: 3))
        daysLabel.backgroundColor = UIColor.hexString(hexString: TextColor_black)
        daysLabel.alpha = 0.8
        return daysLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.lineLbl.isHidden = true
        addSubview(daysLbl)
        addSubview(lineLbl)
    }
    
    var isToDay: Bool = false {
        didSet {
            lineLbl.isHidden = !isToDay
        }
    }
    
    var isWrited: Bool = false {
        didSet {
            self.daysLbl.alpha = isWrited ? 0.8 : 0.4
        }
    }
    
    var dayType: DayType = .workday {
        didSet {
            switch dayType {
            case .saturday:
                self.daysLbl.textColor = UIColor.hexString(hexString: TextColor_blue)
            case .sunday:
                self.daysLbl.textColor = UIColor.hexString(hexString: textColor_red)
            default:
                self.daysLbl.textColor = UIColor.hexString(hexString: TextColor_black)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func clear() {
        self.dayType = .workday
        self.isToDay = false
        self.isWrited = false
        self.daysLbl.text = ""
        self.lineLbl.isHidden = true
    }
    
}

enum DayType {
    case workday
    case saturday
    case sunday
}
