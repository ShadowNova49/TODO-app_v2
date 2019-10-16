//
//  GalleryViewController.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 24.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import UIKit
import Kingfisher
import DZNEmptyDataSet

class GalleryViewController: UIViewController, TodoListObserver {
  @IBOutlet weak var collectionView: UICollectionView!
  
  var requestedTasks: [Item] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    TodoListManager.shared.delegate = self
    TodoListManager.shared.startObservingDatabase(for: .imagesRef)
    
    collectionView.emptyDataSetSource = self
    collectionView.emptyDataSetDelegate = self
  }
}

// MARK: - UICollectionViewDataSource

extension GalleryViewController: UICollectionViewDataSource, DZNEmptyDataSetSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.requestedTasks.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let reusebleIdentifier = "ImageCell"
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusebleIdentifier, for: indexPath) as! ImageCollectionViewCell
    cell.imageView.kf.setImage(with: URL(string: requestedTasks[indexPath.row].attachedImageUrl!), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil, completionHandler: nil)
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension GalleryViewController: UICollectionViewDelegate, DZNEmptyDataSetDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "FromGalleryToGallery", sender: indexPath)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "FromGalleryToGallery" {
      let viewController = segue.destination as! FullScreenImageViewController
      let indexPath = sender as? IndexPath
      viewController.imageUrl = requestedTasks[indexPath!.row].attachedImageUrl!
    }
  }
  
  func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    let str = "This is your image library!"
    let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
    return NSAttributedString(string: str, attributes: attrs)
  }
  
  func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    let str = "But as you can see, it is still empty."
    let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
    return NSAttributedString(string: str, attributes: attrs)
  }
  
  func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
    return UIImage(named: "bgImage")
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
