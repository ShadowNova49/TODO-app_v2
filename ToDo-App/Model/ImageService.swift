//
//  ImageService.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 29.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import Foundation
import Firebase

class ImageService {
    
    private init() {}
    static let shared = ImageService()
    
    /*
    func getItemsArray() -> [Item] {
        
        var items = [Item]()
        
        databaseHandle = ref.child("users/\(self.user.uid)/notes").observe(.value, with: { (snapshot) in
            var newItems = [Item]()
            
            for itemSnapShot in snapshot.children {
                let item = Item(snapshot: itemSnapShot as! DataSnapshot)
                newItems.append(item)
            }
            items = newItems
        })
        
        return items
        */
    
        /*
        let imagesRef = Storage.storage().reference().child("note_attach_image")
        var imagesUrl = [String]()
         
        ???.forEach {
            imagesRef.downloadURL { url, error in
                if let error = error {
                    // Handle any errors
                    print("error: ", error.localizedDescription)
                    return
                }
                
                imagesUrl.append(url!.absoluteString)
        }
        */
    
    func uploadAttachedImage(image attachedImage: UIImage?) -> String? {
        
        var stringImageUrl: String?
        
        let storageRef = Storage.storage().reference().child("note_attach_image").child("\(NSUUID().uuidString).png")
        
        if let uploadData = attachedImage?.pngData() {
            storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    
                    guard let url = url else { return }
                    stringImageUrl = url.absoluteString
                    
                })
            })
        }
        
        return stringImageUrl
    }
    
    /*
     func delete(imageId: String, completion: @escaping () -> ()) {
        let imageDocRef = Firestore.getFirestore().image(id: imageId)
     
     imageDocRef.delete { error in
        if let error = error {
            print("error: ", error.localizedDescription)
            return
        }
     
            DispatchQueue.main.async {
                completion()
            }
        }
     
        Storage.storage().image(id: imageId).delete()
    }
    */
}
