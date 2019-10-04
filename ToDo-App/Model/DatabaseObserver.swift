//
//  DatabaseObserver.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 04.10.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

/*
import Foundation
import Firebase

class DatabaseObserver {
    var user: User = Auth.auth().currentUser!
    var ref: DatabaseReference = Database.database().reference()
    private var databaseHandle: DatabaseHandle!
    var newTasks = [Item]()
    
    func startObservingDatabase (for key: String) -> [Item] {
        databaseHandle = ref.child("users/\(self.user.uid)/notes").observe(.value, with: { (snapshot) in
            
            for itemSnapShot in snapshot.children {
                let item = Item(snapshot: itemSnapShot as! DataSnapshot)
                
                switch key {
                case "ListMode":
                    if item.isDone == false {
                        self.newTasks.append(item)
                    }
                case "Gallery":
                    if item.attachPhotoUrl != nil {
                        self.newTasks.append(item)
                    }
                default:
                    return
                }
            }
        })
        return newTasks
    }
    
    deinit {
        ref.child("users/\(self.user.uid)/notes").removeObserver(withHandle: databaseHandle)
    }
}
*/
