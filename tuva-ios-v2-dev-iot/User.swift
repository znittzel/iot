//
//  User.swift
//  tuva-ios-v2-dev-iot
//
//  Created by Rikard Olsson on 2016-06-09.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation

func == (left: User, rigth: User) -> Bool {
    var result: Bool
    
    result = (left.hashValue == rigth.hashValue)
    
    return result
}

class User : Hashable {
    var objectId: String
    var email: String
    var username: String
    
    var hashValue: Int
    
    init(objectId: String, email: String, username: String) {
        self.hashValue = objectId.hashValue
        self.objectId = objectId
        self.email = email
        self.username = username
    }
}