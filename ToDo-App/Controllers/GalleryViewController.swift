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
    
    var itemsWithImage = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        user = Auth.auth().currentUser
        ref = Database.database().reference()
        imageFetcher()
    }
    
    func imageFetcher() {
        databaseHandle = ref.child("users/\(self.user.uid)/notes").observe(.value, with: { (snapshot) in
            var newItems = [String]()
            
            for itemSnapShot in snapshot.children {
                let item = Item(snapshot: itemSnapShot as! DataSnapshot)
                if item.attachPhotoUrl != nil {
                    newItems.append(item.attachPhotoUrl!)
                }
            }
            
            self.itemsWithImage = newItems
            self.collectionView.reloadData()
        })
    }
    
    deinit {
        ref.child("users/\(self.user.uid)/notes").removeObserver(withHandle: databaseHandle)
    }
}

// MARK: Data source

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsWithImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        //cell.imageView.loadImageUsingCacheWithUrlString(imagesUrl[indexPath.row])
        cell.imageView.kf.setImage(with: URL(string: itemsWithImage[indexPath.row]), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil, completionHandler: nil)
        return cell
    }
}

// MARK: Delegate

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 5 - 50 / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "FromGalleryToGallery", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromGalleryToGallery" {
            let viewController = segue.destination as! FullScreenImageViewController
            let indexPath = sender as? IndexPath
                viewController.imageUrl = itemsWithImage[indexPath!.row]
        }
    }
}
