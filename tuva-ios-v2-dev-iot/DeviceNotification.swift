//
//  Notification.swift
//  tuva-ios-v2-dev-iot
//
//  Created by Rikard Olsson on 2016-06-09.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation

func == (left: DeviceNotification, rigth: DeviceNotification) -> Bool {
    var result: Bool
    
    result = (left.hashValue == rigth.hashValue)
    
    return result
}

class DeviceNotification : Hashable {
    var objectId: String
    var message : String
    var device : Device
    var createdAt : NSDate
    var isRead: Bool
    
    var hashValue: Int
    
    init(objectId: String, dev : Device, message : String, createdAt : NSDate, isRead: Bool) {
        self.hashValue = objectId.hashValue
        self.objectId = objectId
        self.message = message
        self.device = dev
        self.createdAt = createdAt
        self.isRead = isRead
    }
}
