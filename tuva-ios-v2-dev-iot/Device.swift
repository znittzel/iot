//
//  Device.swift
//  tuva-ios-v2-dev-iot
//
//  Created by Rikard Olsson on 2016-06-09.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation

func == (left: Device, rigth: Device) -> Bool {
    var result: Bool
    
    result = (left.hashValue == rigth.hashValue)
    
    return result
}

class Device : Hashable {
    var objectId : String
    var deviceId : String
    var name: String
    var owner: User
    
    var hashValue: Int
    
    init(objectId: String, deviceId: String, name: String, owner: User) {
        self.hashValue = objectId.hashValue
        self.objectId = objectId
        self.deviceId = deviceId
        self.name = name
        self.owner = owner
    }
}