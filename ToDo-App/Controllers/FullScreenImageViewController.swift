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
            
            let hideGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.hideImage))
            fullScreenNoteImage.addGestureRecognizer(hideGesture)
        }
    }

    var image: UIImage?
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if imageUrl == nil {
            self.fullScreenNoteImage.image = image
        } else {
            self.fullScreenNoteImage.loadImageUsingCacheWithUrlString(imageUrl!)
        }
        
    }
    
    @objc func hideImage() {
        dismiss(animated: true, completion: nil)
    }
}
