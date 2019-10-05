//
//  ImageCollectionViewCell.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 29.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
      super.awakeFromNib()
      setupCell()
    }
    
    private func setupCell() {
      layer.borderWidth = 1
      layer.borderColor = UIColor.black.cgColor
      layer.cornerRadius = 8
    }
}
