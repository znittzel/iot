//
//  TuvaTools.swift
//  tuva-ios-v2-dev-iot
//
//  Created by Rikard Olsson on 2016-06-10.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import Foundation
import Parse

class TuvaTools {
    
    private static func __createUserFromPFObject(pfObject: PFObject) -> User? {
        var user: User?
        
        if let objectId = pfObject.objectId {
            
            if objectId != "" {
                user = User(objectId: objectId, email: pfObject.valueForKey("email") as! String, username: pfObject.valueForKey("username") as! String)
            }
        }
        
        return user
    }
    
    private static func __createPFObjectFromUser(user: User) -> PFObject {
        let pfObject = PFUser()
        
        pfObject.objectId = user.objectId
        pfObject.setObject(user.email, forKey: "email")
        pfObject.setObject(user.username, forKey: "username")
        
        return pfObject
        
    }
    
    private static func __createDeviceFromPFObject(pfObject: PFObject) -> Device? {
        var device: Device?
        if let pfOwner = pfObject.objectForKey("owner") {
            if let owner = __createUserFromPFObject(pfOwner as! PFObject) {
                device = Device(objectId: pfObject.objectId!, deviceId: pfObject.valueForKey("deviceId") as! String, name: pfObject.valueForKey("name") as! String, owner: owner)
            }
        }
        
        return device
    }
    
    private static func __createPFObjectFromDevice(device: Device) -> PFObject {
        let pfObject = PFObject(className: "Device")
        
        pfObject.objectId = device.objectId
        pfObject.setObject(device.name, forKey: "name")
        pfObject.setObject(device.deviceId, forKey: "deviceId")
        pfObject.setObject( __createPFObjectFromUser(device.owner), forKey: "owner")
        
        return pfObject
    }
    
    private static func __createDeviceNotificationFromPFObject(pfObject: PFObject, device: Device) -> DeviceNotification? {
        var deviceNotification: DeviceNotification?

        deviceNotification = DeviceNotification(objectId: pfObject.objectId!, dev: device, message: pfObject.valueForKey("message") as! String, createdAt: pfObject.valueForKey("createdAt") as! NSDate, isRead: pfObject.valueForKey("isRead") as! Bool)
        
        
        return deviceNotification
    }
    
    
    static func user_get(objectId: String, completion: (user: User?, error: NSError?) -> Void) {
        let userQuery = PFQuery(className: "_User")
        userQuery.getObjectInBackgroundWithId(objectId) { (pfUser: PFObject?, error: NSError?) in
            if error == nil && pfUser != nil {
                completion(user: __createUserFromPFObject(pfUser!), error: error)
            } else {
                completion(user: nil, error: error)
            }
        }
    }
    
    static func device_get_list(user: User, completion: (devices: [Device]?, error: NSError?) -> Void) {
        let query = PFQuery(className: "Device")
        query.whereKey("owner", equalTo: __createPFObjectFromUser(user))
        query.includeKey("owner")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if objects != nil && error == nil {
                var devices = [Device]()
                for object in objects! {
                    if let device = __createDeviceFromPFObject(object) {
                        devices.append(device)
                    }
                }
                
                completion(devices: devices, error: error)
            } else {
                completion(devices: nil, error: error)
            }
        }
    }
    
    static func deviceNotification_read(deviceNotification: DeviceNotification, read: Bool, completion: (done: Bool, error: NSError?) -> Void) {
        let query = PFQuery(className: "DeviceNotification")
        query.getObjectInBackgroundWithId(deviceNotification.objectId) { (pfObject: PFObject?, error: NSError?) in
            if error != nil {
                completion(done: false, error: error)
            } else if let pfDeviceNotification = pfObject {
                pfDeviceNotification.setValue(read, forKey: "isRead")
                pfDeviceNotification.saveInBackground()
                
                completion(done: true, error: error)
            }
        }
    }
    
    static func deviceNotification_get_list(device: Device, completion: (deviceNotifications: [DeviceNotification]?, error: NSError?) -> Void) {
        let query = PFQuery(className: "DeviceNotification")
        query.whereKey("device", equalTo: __createPFObjectFromDevice(device))
        query.includeKey("device")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if error == nil && objects != nil {
                var deviceNotifications = [DeviceNotification]()
                for object in objects! {
                    if let deviceNotification = __createDeviceNotificationFromPFObject(object, device: device) {
                        deviceNotifications.append(deviceNotification)
                    }
                }
                
                completion(deviceNotifications: deviceNotifications, error: error)
            } else {
                completion(deviceNotifications: nil, error: error)
            }
        }
        
    }
}