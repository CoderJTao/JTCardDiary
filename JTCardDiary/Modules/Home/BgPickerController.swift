//
//  BgPickerController.swift
//  JTCardDiary
//
//  Created by 江涛 on 2018/12/11.
//  Copyright © 2018 江涛. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class BgPickerController: UIViewController {
    
    private let colorArr = ["9966CC", "26BFFF", "FFC09F", "A3A380", "FCE85A", "1DB0B8", "6AECD2", "F29F3F", "F2753F", "FF5983", "D699BA", "F17C67", "E20048", "01939A", "AFDFCC", "FABD6B", "D2D2D2", "8E8E93", "404040", "2D2D2D"]
    private let Color_Tag = 301
    
    var pickerColor: (String) -> () = { _ in
        
    }
    
    var pickImage: (UIImage) -> () = { _ in
        
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<colorArr.count {
            let color = self.view.viewWithTag(Color_Tag + index)
            color?.clipsToBounds = true
            color?.layer.cornerRadius = 18
            
            color?.isUserInteractionEnabled = true
            color?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colorTap(_:))))
        }
    }

    @IBAction func closeClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.bottomConstraint.constant = 360
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func photoClick(_ sender: UIButton) {
        if self.checkPhotoLibraryPermission() {
            self.selectPhoto()
        } else {
            // 没有授权
        }
    }
    
    @objc func colorTap(_ sender: UITapGestureRecognizer) {
        guard let vw = sender.view else { return }
        
        let color = colorArr[vw.tag - Color_Tag]
        
        self.pickerColor(color)
        
        self.closeClick(UIButton())
    }
    

}

extension BgPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func selectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // do nothing
        picker.dismiss(animated: true, completion: nil)
        picker.removeFromParent()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            self.pickImage(pickedImage)
            self.closeClick(UIButton())
        }
        
        picker.dismiss(animated: true, completion: nil)
        picker.removeFromParent()
    }

    
    
    
    private func checkPhotoLibraryPermission() -> Bool {
        let libAuth = PHPhotoLibrary.authorizationStatus()
        switch libAuth {
        case .authorized, .notDetermined:
            return true
        default:
            return false
        }
    }
}

