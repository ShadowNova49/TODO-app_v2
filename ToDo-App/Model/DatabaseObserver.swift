//
//DatabaseObserver.swift
//ToDo-App
//
//Created by Никита Шалыгин on 04.10.2019.
//Copyright © 2019 Никита Шалыгин. All rights reserved.
//
//
//
//import Foundation
//import Firebase
//
//protocol DatabaseObserver {
//  var user: User { get set }
//  var ref: DatabaseReference { get set }
//  var databaseHandle: DatabaseHandle! { get set }
//  var newItem: [Item] { get set }
//  
//  mutating func startObservingDatabase(_: String) -> [Item]
//}
//
//extension DatabaseObserver {
//  mutating func startObservingDatabase() -> [Item] {
//    databaseHandle = ref.child("users/\(self.user.uid)/notes").observe(.value, with: { (snapshot) in
//
//      for itemSnapShot in snapshot.children {
//        let item = Item(snapshot: itemSnapShot as! DataSnapshot)
//        if item.isDone == false {
//          self.newItem.append(item)
//        }
//      }
//
//    })
//    return newItem
//  }
//}
