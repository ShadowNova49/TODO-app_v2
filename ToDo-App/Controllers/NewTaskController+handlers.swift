//
//  NewTaskController+handlers.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 24.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit
import Firebase

extension NewTaskViewControler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
    
    var selectedImageFromPicker: UIImage?
    var selectedImageSize: String?
    
    if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
      selectedImageFromPicker = editedImage
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      selectedImageFromPicker = originalImage
    }
    
    if let imageData = selectedImageFromPicker!.pngData() {
      let bytes = imageData.count
      let bcf = ByteCountFormatter ()
      bcf.allowedUnits = [.useMB]
      bcf.countStyle = .file
      selectedImageSize = bcf.string(fromByteCount: Int64(bytes))
    }
    
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
