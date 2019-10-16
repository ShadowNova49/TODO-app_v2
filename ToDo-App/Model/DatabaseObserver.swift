//
//  DatabaseObserver.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 04.10.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import Foundation
import Firebase

protocol TodoListObserver {
  //var requestedTasks: [Item] { get set }
  func itemListDidChanged([Item])
}

enum ObserveCase {
  case doneTasks, undoneTasks, imagesRef
}

protocol TodoListManagerProtocol {
  var delegate: TodoListObserver! { get set }
  
  func createNewTodo(noteName: String, noteDescription: String?, dateTime: String?, attachedImage: UIImage?) -> Int
  func updateExistingTodo(id: Int, noteName: String, noteDescription: String?, dateTime: String?, attachedImage: UIImage?)
  func startObservingDatabase(for key: ObserveCase)
  func deleteTodo(with noteRef: String, and attachedImageUid: String?)
}

protocol TodoListManagerProtocol2 {
  
  var delegate: TodoListObserver! { get set }
  
  func createItem(item: Item) -> Item
  func updateItem(item: Item)
  func deleteItem(item: Item)
  
}


class TodoListLocalManager: TodoListManagerProtocol {
  var delegate: TodoListObserver!
  
  
  var todoListItems: [Item]
  
  func updateExistingTodo(id: Int, noteName: String, noteDescription: String?, dateTime: String?, attachedImage: UIImage?) {
    todoListItems.first { $0.id == id }
  }
  
  
  func createNewTodo(noteName: String, noteDescription: String?, dateTime: String?, attachedImage: UIImage?) -> Int {
    <#code#>
  }
  
  func deleteTodo(with noteRef: String, and attachedImageUid: String?) {
    <#code#>
  }
  
}


//class TodoListManager: TodoListManagerProtocol {
//  static let shared = TodoListManager()
//  var delegate: TodoListObserver!
//
//  private let ref = Database.database().reference()
//  private var databaseHandle: DatabaseHandle!
//
//  //MARK: - Function that create reference on current user
//
//  private func getCurrentUser() -> User {
//    return Auth.auth().currentUser!
//  }
//
//  //MARK: - Function that take Storage image reference
//
//  private func getImageRef(imageUid: String) -> StorageReference {
//    return Storage.storage().reference().child("note_attach_image").child("\(imageUid).png")
//  }
//
//  //MARK: - Function that take note reference
//
//  private func getNoteRef(noteUid: String) -> DatabaseReference {
//    return ref.child("users/\(getCurrentUser().uid)/notes").child(noteUid)
//  }
//
//  ///MARK: - Function that create template of new Todo
//
//  func createNewTodo(noteName: String, noteDescription: String?, dateTime: String?, attachedImage: UIImage?) {
//    let imageUid = UUID().uuidString
//    let noteUid = imageUid
//    let storageRef = getImageRef(imageUid: imageUid)
//    var noteItem: Item?
//
//    if let uploadData = attachedImage?.pngData() {
//      storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
//
//        storageRef.downloadURL(completion: { (url, err) in
//          if let err = err {
//            print(err)
//            return
//          }
//          guard let url = url else { return }
//
//          noteItem = Item(name: noteName, noteUid: noteUid, noteDescription: noteDescription, dateTime: dateTime,
//                          attachedImageUrl: url.absoluteString, attachedImageUid: imageUid)
//          self.upload(note: noteItem!, noteUid: noteUid)
//        })
//      })
//    } else {
//      noteItem = Item(name: noteName, noteUid: noteUid, noteDescription: noteDescription, dateTime: dateTime,
//                      attachedImageUrl: nil, attachedImageUid: nil)
//      self.upload(note: noteItem!, noteUid: noteUid)
//    }
//  }
//
//  //MARK: - Function that uploading image into Firebase database
//
//  private func upload(note item: Item, noteUid: String) {
//    let noteRef = self.ref.child("users/\(getCurrentUser().uid)/notes").child(noteUid)
//    noteRef.setValue(item.toAnyObject())
//  }
//
//
//  //MARK: - Function that updating Todo's fields
//
//  func updateExistingTodo(with data: [AnyHashable : Any], and noteRef: String) {
//    getNoteRef(noteUid: noteRef).updateChildValues(data)
//  }
//
//  //MARK: - Function that delete Todo and linked image (if exist) from Firebase
//
//  func deleteTodo(with noteRef: String, and attachedImageUid: String?) {
//    getNoteRef(noteUid: noteRef).removeValue()
//    if attachedImageUid != nil {
//      let imageRef = getImageRef(imageUid: attachedImageUid!)
//      imageRef.delete {
//        error in
//        if let error = error {
//          print(error)
//        } else {
//          print("File deleted successfully")
//        }
//      }
//    }
//  }
//
//  //MARK: - Function that receives a snapshot that contains the data at the specified
//  // location in the database at the time of the event in its value property.
//
//  func startObservingDatabase(for key: ObserveCase) {
//    databaseHandle = ref.child("users/\(getCurrentUser().uid)/notes").observe(.value, with: { (snapshot) in
//      var newInnerItem: [Item] = []
//      switch key {
//      case .doneTasks:
//        for itemSnapShot in snapshot.children {
//          let snapshotItem = itemSnapShot as! DataSnapshot
//          let item = Item(data: snapshotItem.value as! Dictionary<String, Any>)
//          if item.isDone == true {
//            newInnerItem.append(item)
//          }
//        }
//      case .undoneTasks:
//        for itemSnapShot in snapshot.children {
//          let snapshotItem = itemSnapShot as! DataSnapshot
//          let item = Item(data: snapshotItem.value as! Dictionary<String, Any>)
//          if item.isDone == false {
//            newInnerItem.append(item)
//          }
//        }
//      case .imagesRef:
//        for itemSnapShot in snapshot.children {
//          let snapshotItem = itemSnapShot as! DataSnapshot
//          let item = Item(data: snapshotItem.value as! Dictionary<String, Any>)
//          if item.attachedImageUrl != nil {
//            newInnerItem.append(item)
//          }
//        }
//      }
//      self.delegate.requestedTasks = newInnerItem
//    })
//  }
//
//  deinit {
//    ref.child("users/\(getCurrentUser().uid)/notes").removeObserver(withHandle: databaseHandle)
//  }
//}
