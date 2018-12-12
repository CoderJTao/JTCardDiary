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
            print("----")
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

