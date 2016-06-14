//
//  HomeViewController.swift
//  tuva-ios-v2-dev-iot
//
//  Created by Rikard Olsson on 2016-06-14.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

class DeviceViewController : UITableViewController {
    
    var activeUser = User(objectId: "rikard", email: "rikard@murva.se", username: "RikardOlsson")
    var devices = [Device]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        devices.append(Device(objectId: "1111111", deviceId: "1111111", name: "SmartSense Camera", owner: self.activeUser, type: "camera"))
        devices.append(Device(objectId: "2222222", deviceId: "2222222", name: "SmartSense Motion", owner: self.activeUser, type: "sensor-motion"))
        devices.append(Device(objectId: "3333333", deviceId: "3333333", name: "SmartSense Door", owner: self.activeUser, type: "sensor-door"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DeviceTableViewCell", forIndexPath: indexPath) as! DeviceTableViewCell
        let device = self.devices[indexPath.row]
        
        cell.deviceimage.image = TuvaTools.device_get_image_by_type(device)
        cell.devicename.text = device.name
        
        if device.objectId == "3333333" {
            cell.devicestatus.text = "Closed"
            cell.devicestatus.textColor = UIColor.redColor()
        } else {
            cell.devicestatus.text = "No connection"
        }
        
        return cell
    }
    
    
}
