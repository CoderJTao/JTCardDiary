//
//  JGProgressHUDWrapper.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/11/29.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import JGProgressHUD

class JGProgressHUDWrapper: NSObject {
    
    fileprivate var hud: JGProgressHUD?
    
    var content: String?
    
    var detailContent: String?
    
    var indicatorView: JGProgressHUDIndicatorView?
    
    fileprivate var showCompletion: (() -> ())?
    
    fileprivate var dismissCompletion: (() -> ())?
    
    fileprivate var state: HUDState = .idle
    var status: HUDState {
        return self.state
    }
    
    override init() {
        super.init()
        
        self.hud = JGProgressHUD(style: .dark)
        self.hud!.delegate = self
        
        self.state = .idle
    }
    
    
    
    func show(_ view: UIView, completion: (() -> ())?) {
        if self.hud!.isVisible {
            self.hud!.dismiss()
        }
        if let text = self.content {
            self.hud!.textLabel.text = text
        }
        
        if let text = self.detailContent {
            self.hud!.detailTextLabel.text = text
        }
        
        if let indicator = self.indicatorView {
            self.hud!.indicatorView = indicator
        }
        
        self.showCompletion = completion
        
        self.state = .show
        
        DispatchQueue.main.async(execute: {
            self.hud!.show(in: view)
        })
    }
    
    func dismiss(_ completion: (() -> ())?) {
        self.dismissCompletion = completion
        
        self.state = .dismiss
        
        DispatchQueue.main.async(execute: {
            self.hud!.dismiss()
        })
    }
}

extension JGProgressHUDWrapper: JGProgressHUDDelegate {
    func progressHUD(_ progressHUD: JGProgressHUD, willPresentIn view: UIView) {
        // do nothing
    }
    
    func progressHUD(_ progressHUD: JGProgressHUD, didPresentIn view: UIView) {
        if let completion = self.showCompletion {
            completion()
        }
    }
    
    func progressHUD(_ progressHUD: JGProgressHUD, willDismissFrom view: UIView) {
        // do nothing
        
    }
    
    func progressHUD(_ progressHUD: JGProgressHUD, didDismissFrom view: UIView) {
        if let completion = self.dismissCompletion {
            completion()
        }
        
        self.state = .idle
    }
}

enum HUDState {
    case idle, show, dismiss
}

