//
//  UIViewController+Extension.swift
//  JTDairy
//
//  Created by JiangT on 2018/10/26.
//  Copyright © 2018 江涛. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// 设置状态栏背景颜色
    func setStatusBarBackgroundColor(color: UIColor = UIColor.white) {
        if let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIView {
            if let statusBar = statusBarWindow.value(forKey: "statusBar") as? UIView {
                statusBar.backgroundColor = color
            }
        }
    }
    
    /// 设置导航栏背景
    func setNavigationBarBackGroundColor() {
        //设置导航栏透明
//        [self.navigationController.navigationBar setTranslucent:true];
        self.navigationController?.navigationBar.isTranslucent = true
        //把背景设为空
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
    
    // MARK: - hide navigation bar hair line
    func hideNavigationBarHairLine() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - show custom navigation back button
    func showNavigationBackButton() {
        self.navigationItem.hidesBackButton = true
        
        let item = UIBarButtonItem(image: UIImage(named: "arrow_left"), style: .plain, target: self, action: #selector(onNavigationBackPressed(_:)))
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.hexString(hexString: "2D2D2D")
    }
    
    // MARK: - show navigation back cancel button
    func showNavigationCancelBackButton() {
//        self.navigationItem.hidesBackButton = true
//        
//        let item = UIBarButtonItem(title: "button_cancel", style: .plain, target: self, action: #selector(onNavigationBackPressed(_:)))
//        self.navigationItem.leftBarButtonItem = item
    }
    
    @objc func onNavigationBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
