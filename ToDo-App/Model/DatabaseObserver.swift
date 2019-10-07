//
//DatabaseObserver.swift
//ToDo-App
//
//Created by Никита Шалыгин on 04.10.2019.
//Copyright © 2019 Никита Шалыгин. All rights reserved.
//

//import Foundation
//import Firebase
//
//protocol DatabaseObserver {
//  var user: User! { get }
//  var ref: DatabaseReference! { get }
//  var databaseHandle: DatabaseHandle! { get set }
//  var newItem: [Item] { get set }
//
//  func startObservingDatabase(for key: ObserveCase)
//}
//
//enum ObserveCase {
//  case doneTasks, undoneTasks, imagesRef
//}
//
//extension DatabaseObserver {
//  var user: User! {
//    return Auth.auth().currentUser
//  }
//
//  var ref: DatabaseReference! {
//    return Database.database().reference()
//  }
//
//  mutating func startObservingDatabase(for key: ObserveCase) {
//    databaseHandle = ref.child("users/\(self.user.uid)/notes").observe(.value, with: { (snapshot) in
//      var newInnerItem: [Item] = []
//
//      switch key {
//      case .doneTasks:
//        for itemSnapShot in snapshot.children {
//          let item = Item(snapshot: itemSnapShot as! DataSnapshot)
//          if item.isDone == true {
//            newInnerItem.append(item)
//          }
//        }
//      case .undoneTasks:
//        for itemSnapShot in snapshot.children {
//          let item = Item(snapshot: itemSnapShot as! DataSnapshot)
//          if item.isDone == false {
//            newInnerItem.append(item)
//          }
//        }
//      case .imagesRef:
//        for itemSnapShot in snapshot.children {
//          let item = Item(snapshot: itemSnapShot as! DataSnapshot)
//          if item.attachedImageUrl != nil {
//            newInnerItem.append(item)
//          }
//        }
//      }
//     self.newItem = newInnerItem
//    })
//  }
//}
//
//
//protocol AuthManagerDelegate {
//  func userAuthenticated()
//}
//
//class AuthManager {
//
//  func signUp() {}
//
//  func singOut() {}
//
//}
//
//
//protocol TodoListObserver: class {
//
//  func todoListUpdated(_ list: [Item])
//
//}
//
//
//class TodoListManager {
//
//  static let shared = TodoListManager()
//
//  weak var observer: TodoListObserver?
//
//  func getTodoList() -> [Item] {
//
//  }
//
//  func createTodoItem() {}
//
//
//
//}
