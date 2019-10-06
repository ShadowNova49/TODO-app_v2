//
//  FullScreenImageViewController.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 28.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {
  @IBOutlet weak var fullScreenNoteImage: UIImageView! {
    didSet{
      fullScreenNoteImage.frame = UIScreen.main.bounds
      fullScreenNoteImage.backgroundColor = .white
      fullScreenNoteImage.contentMode = .scaleAspectFit
      fullScreenNoteImage.isUserInteractionEnabled = true
      
      let hideGesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.hideImage))
      fullScreenNoteImage.addGestureRecognizer(hideGesture)
      
      let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(self.pinchGesture(sender:)))
      fullScreenNoteImage.addGestureRecognizer(pinchGesture)
    }
  }
  
  var image: UIImage?
  var imageUrl: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if imageUrl == nil {
      self.fullScreenNoteImage.image = image
    } else {
      self.fullScreenNoteImage.kf.setImage(with: URL(string: imageUrl!), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil, completionHandler: nil)
    }
  }
  
  /** Function that handle pinch gesture **/
  
  @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
    guard sender.view != nil else { return }
    
    if sender.state == .began || sender.state == .changed {
      sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
      sender.scale = 1.0
    }
  }
  
  /** Function that dismissing full screen mode **/
  
  @objc func hideImage() {
    dismiss(animated: true, completion: nil)
  }
}
