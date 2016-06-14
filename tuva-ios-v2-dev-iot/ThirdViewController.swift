//
//  ThirdViewController.swift
//  tuva-ios-v2-dev-iot
//
//  Created by Rikard Olsson on 2016-06-09.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit
import Parse

class ThirdViewController : UITableViewController {
    var devices = [Device]()
    var deviceNotifications = [Device: [DeviceNotification]]()
    var handler = MasterEventHandler()
    var activeUser: User?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Refresh Control
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(ThirdViewController.loadData), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Fetch data
        self.loadData()
        self.refreshControl!.beginRefreshing()
    }
    
    func loadData() {
        let userObjectId = "jel0VruBfJ"
        
        self.deviceNotifications = [Device: [DeviceNotification]]()
        
        handler.loadSlave("device") { (error) in
            for device in self.devices {
                TuvaTools.deviceNotification_get_list(device, completion: { (deviceNotifications, error) in
                    if deviceNotifications != nil {
                        
                        if self.deviceNotifications[device] != nil {
                            self.deviceNotifications[device]!.appendContentsOf(deviceNotifications!)
                        } else {
                            self.deviceNotifications[device] = deviceNotifications!
                        }
                        
                        var sorted_deviceNotifications = [Device:[DeviceNotification]]()
                        
                        for dev_not in self.deviceNotifications {
                            let dev_not_sorted = dev_not.1.sort({ (not1, not2) -> Bool in
                                return not1.createdAt.compare(not2.createdAt) == NSComparisonResult.OrderedDescending
                            })
                            sorted_deviceNotifications[dev_not.0] = dev_not_sorted
                        }
                        
                        self.deviceNotifications = sorted_deviceNotifications
                        
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                })
            }
        }
        
        handler.loadSlave("user") { (error) in
            self.handler.fetchSlave("device", callback: { (fire) in
                TuvaTools.device_get_list(self.activeUser!, completion: { (remote_devices, error) in
                    if remote_devices != nil {
                        self.devices = remote_devices!
                        fire(error)
                    }
                })
            })
        }
        
        handler.fetchSlave("user") { (fire) in
            TuvaTools.user_get(userObjectId, completion: { (user, error) in
                if user != nil {
                    self.activeUser = user
                    fire(error)
                }
            })
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let count = deviceNotifications.count
        
        return count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section_dev = self.deviceNotifications.startIndex.advancedBy(section)
        let device = self.deviceNotifications.keys[section_dev]
        
        let count = deviceNotifications[device]!.count
        
        return count
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DeviceNotificationTableViewCell", forIndexPath: indexPath) as! DeviceNotificationTableViewCell
        let section = self.deviceNotifications.startIndex.advancedBy(indexPath.section)
        let device = self.deviceNotifications.keys[section]
        let deviceNotification = self.deviceNotifications[device]![indexPath.row]
        
        cell.messageLabel.text = "\(deviceNotification.device.name) is saying: \(deviceNotification.message)"
        
        if deviceNotification.isRead {
            cell.notification.image = UIImage(named: "alert-opened")
        } else {
            cell.notification.image = UIImage(named: "alert")
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let section = self.deviceNotifications.startIndex.advancedBy(indexPath.section)
        let device = self.deviceNotifications.keys[section]
        let deviceNotification = self.deviceNotifications[device]![indexPath.row]
        
        self.performSegueWithIdentifier("DeviceNotificationSegue", sender: deviceNotification)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DeviceNotificationSegue" {
            let destinationController = segue.destinationViewController as! DeviceNotificationViewController
            let deviceNotification = sender as? DeviceNotification
            destinationController.deviceNotification = deviceNotification
        }
    }
    
}
