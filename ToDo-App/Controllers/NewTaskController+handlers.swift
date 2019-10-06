//
//  NewTaskController+handlers.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 24.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit
import Firebase
//import Photos

extension NewTaskViewControler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // Local variable inserted by Swift 4.2 migrator.
    let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
    
    var selectedImageFromPicker: UIImage?
    //var selectedImageName: String?
    var selectedImageSize: String?
    
    if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
      selectedImageFromPicker = editedImage
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      selectedImageFromPicker = originalImage
    }
    
    if let imageData = selectedImageFromPicker!.pngData() {
      let bytes = imageData.count
      let sizeInMb = Double(bytes) / pow(1024, 2) // Convert bytes to megabytes
      selectedImageSize = "\(String(format: "%.2f", sizeInMb)) MB"
    }
    
//     if let asset = info["UIImagePickerControllerPHAsset"] as? PHAsset {
//      if let fileName = (asset.value(forKey: "filename")) as? String {
//        selectedImageSize = fileName
//      } else {
//          selectedImageSize = generateNameForImage()
//          print(selectedImageName)
//        }
//     }
    
    if let selectedImage = selectedImageFromPicker {
      attachedImage = selectedImage
      attachedImageView.image = attachedImage
      imageNameLabel.text = generateNameForImage()
      imageSizeLabel.text = selectedImageSize
      cancelImageButton.isHidden = false
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}

func generateNameForImage() -> String {
  return "IMG_random_string"
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
  return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
