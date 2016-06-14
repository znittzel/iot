//
//  DeviceNotificationViewController.swift
//  tuva-ios-v2-dev-iot
//
//  Created by Rikard Olsson on 2016-06-10.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

class DeviceNotificationViewController : UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    var deviceNotification: DeviceNotification?
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if deviceNotification != nil {
            TuvaTools.deviceNotification_read(deviceNotification!, read: true, completion: { (done, error) in
                if done {
                    self.dateTime.text = self.deviceNotification!.createdAt.description
                    self.name.text = self.deviceNotification!.device.name
                    self.message.text = self.deviceNotification!.message
                    
                }
            })
        }
    }
}
