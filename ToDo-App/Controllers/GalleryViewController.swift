//
//  GalleryViewController.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 24.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class GalleryViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  
  var user: User!
  var ref: DatabaseReference!
  private var databaseHandle: DatabaseHandle!
  
  var itemsImageUrls: [Item] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    user = Auth.auth().currentUser
    ref = Database.database().reference()
    startObservingDatabase()
  }
  
  //MARK: - Function that receives a snapshot that contains the data at the specified location in the
  //database at the time of the event in its value property. In this case th list of items with images 
  
  func startObservingDatabase() {
    databaseHandle = ref.child("users/\(self.user.uid)/notes").observe(.value, with: { (snapshot) in
      var newItemsImageUrls: [Item] = []

      for itemSnapShot in snapshot.children {
        let item = Item(snapshot: itemSnapShot as! DataSnapshot)
        if item.attachedImageUrl != nil {
          newItemsImageUrls.append(item)
        }
      }
      self.itemsImageUrls = newItemsImageUrls
      self.collectionView.reloadData()
    })
  }

  deinit {
    ref.child("users/\(self.user.uid)/notes").removeObserver(withHandle: databaseHandle)
    print("reference has been removed")
  }
}

// MARK: - UICollectionViewDataSource

extension GalleryViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.itemsImageUrls.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let reusebleIdentifier = "ImageCell"
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusebleIdentifier, for: indexPath) as! ImageCollectionViewCell
    cell.imageView.kf.setImage(with: URL(string: itemsImageUrls[indexPath.row].attachedImageUrl!), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil, completionHandler: nil)
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension GalleryViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "FromGalleryToGallery", sender: indexPath)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "FromGalleryToGallery" {
      let viewController = segue.destination as! FullScreenImageViewController
      let indexPath = sender as? IndexPath
      viewController.imageUrl = itemsImageUrls[indexPath!.row].attachedImageUrl!
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let amount = CGFloat(3)
    let spaceSummary = CGFloat(50)
    let cellWidth = (collectionView.frame.width / amount) - (spaceSummary / amount)
    return CGSize(width: cellWidth, height: cellWidth)
  }
  
  internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
  }
}
