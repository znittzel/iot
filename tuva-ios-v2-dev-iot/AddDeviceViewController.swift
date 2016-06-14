//
//  AddDeviceViewController.swift
//  tuva-ios-v2-dev-iot
//
//  Created by Rikard Olsson on 2016-06-14.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

class AddDeviceViewController: UIViewController {
    
    @IBOutlet weak var authorizationTextField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func checkButtonAction(sender: AnyObject) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        checkButton.enabled = false
        checkButton.setTitle("Checking...", forState: UIControlState())
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.checkButton.enabled = true
            self.activityIndicator.stopAnimating()
            self.checkButton.setTitle("Check", forState: UIControlState())
            
            let alertController = UIAlertController(title: "Failed", message:
                "Couldnt connect to device!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
