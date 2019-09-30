//
//  NewTaskController+handlers.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 24.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit
import Firebase
import Photos

extension NewTaskViewControler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        var selectedImageFromPicker: UIImage?
        var selectedImageName: String?
        var selectedImageSize: String?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        
        if let imageData = selectedImageFromPicker!.pngData() {
            let bytes = imageData.count
            //let kB = Double(bytes) / 1000.0 // Note the difference
            let KB = Double(bytes) / 1024.0 // Note the difference
            print(KB)
        }
        
        if let asset = info["UIImagePickerControllerPHAsset"] as? PHAsset {
            let assetResources = PHAssetResource.assetResources(for: asset)
            selectedImageName = assetResources.first!.originalFilename
        }
        
        if let selectedImage = selectedImageFromPicker {
            //print(selectedImageName)
            attachPhotoUrl = selectedImage
            attachingImageView.image = attachPhotoUrl
            imageNameLabel.text = selectedImageName
            //imageSizeLabel.text = selectedImageSize
            //print(selectedImageSize)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
}

func generateNameForImage() -> String {
    return "IMG_random_string"
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
