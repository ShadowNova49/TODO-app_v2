//
//  Item.swift
//
//
//  Created by Никита Шалыгин on 15.09.2019.
//

import Foundation
import FirebaseDatabase

class Item {
  let ref: DatabaseReference?
  let name: String?
  let noteDescription: String?
  let dateTime: String?
  let attachedImageUrl: String?
  let isDone: Bool
  let attachedImageUid: String?
  
  init(name: String?, noteDescription: String?, dateTime: String?, attachedImageUrl: String?, attachedImageUid: String?) {
    self.ref = nil
    self.name = name
    self.noteDescription = noteDescription
    self.dateTime = dateTime
    self.attachedImageUrl = attachedImageUrl
    self.attachedImageUid = attachedImageUid
    self.isDone = false
  }
  
  init(snapshot: DataSnapshot) {
    ref = snapshot.ref
    
    let data = snapshot.value as! Dictionary<String, Any>
    self.name = data["name"] as? String
    self.noteDescription = data["noteDescription"] as? String
    self.dateTime = data["dateTime"] as? String
    self.attachedImageUrl = data["attachedImageUrl"] as? String
    self.attachedImageUid = data["attachedImageUid"] as? String
    self.isDone = data["isDone"] as! Bool
  }
  
  func toAnyObject() -> Any {
    return [
      "name": name,
      "noteDescription": noteDescription,
      "dateTime": dateTime,
      "attachedImageUrl": attachedImageUrl,
      "attachedImageUid": attachedImageUid,
      "isDone": isDone
    ]
  }
}
