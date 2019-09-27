//
//  Note.swift
//  ToDo-App
//
//  Created by Никита Шалыгин on 23.09.2019.
//  Copyright © 2019 Никита Шалыгин. All rights reserved.
//

import Foundation


class Note: NSObject {
    var name: String?
    var noteDescription: String?
    var dateTime: String?
    //var profileImageUrl: String?
    //var isDone: Bool
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String
        self.noteDescription = dictionary["noteDescription"] as? String
        self.dateTime = dictionary["dateTime"] as? String
        //self.profileImageUrl = data["profileImageUrl"] as? String
        //self.isDone = data["isDone"] as! Bool
    }
}
