//
//  Item.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 15.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import Foundation

class Item {
  let noteUid: String?
  let name: String?
  let noteDescription: String?
  let dateTime: String?
  let attachedImageUrl: String?
  let isDone: Bool
}

//class Item {
//  let noteUid: String?
//  let name: String?
//  let noteDescription: String?
//  let dateTime: String?
//  let attachedImageUrl: String?
//  let isDone: Bool
//  let attachedImageUid: String?
//
//  init(name: String?, noteUid: String?, noteDescription: String?, dateTime: String?, attachedImageUrl: String?, attachedImageUid: String?) {
//    self.name = name
//    self.noteDescription = noteDescription
//    self.dateTime = dateTime
//    self.attachedImageUrl = attachedImageUrl
//    self.attachedImageUid = attachedImageUid
//    self.isDone = false
//    self.noteUid = noteUid
//  }
//
//  init(data: Dictionary<String, Any>) {
//    self.name = data["name"] as? String
//    self.noteDescription = data["noteDescription"] as? String
//    self.dateTime = data["dateTime"] as? String
//    self.attachedImageUrl = data["attachedImageUrl"] as? String
//    self.attachedImageUid = data["attachedImageUid"] as? String
//    self.isDone = data["isDone"] as! Bool
//    self.noteUid = data["noteUid"] as? String
//  }
//
//  func toAnyObject() -> Any {
//    return [
//      "name": name as Any,
//      "noteUid": noteUid as Any,
//      "noteDescription": noteDescription as Any,
//      "dateTime": dateTime as Any,
//      "attachedImageUrl": attachedImageUrl as Any,
//      "attachedImageUid": attachedImageUid as Any,
//      "isDone": isDone
//    ]
//  }
//}
