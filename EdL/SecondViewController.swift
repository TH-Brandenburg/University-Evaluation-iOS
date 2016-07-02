//
//  SecondViewController.swift
//  THBEval
//
//  Created by Patrick on 19.06.16.
//  Copyright © 2016 THB. All rights reserved.
//

import UIKit
import SwiftyJSON

class SecondViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var messageLabel: UILabel!
    
    var toPass: String!
    
    
    // Locking view to Portrait-Mode
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewDidLoad() {
        let jsonStringData = toPass
        //Convert String to NSString
        let jsonNSStringData = jsonStringData as NSString!
        
        //Convert NSString to NSData
        let data = jsonNSStringData.dataUsingEncoding(NSUTF8StringEncoding)!
        
        // Validating JSON
        let json = JSON(data: data)
        if let host = json["host"].string {
            print(host)
        }
        if let voteToken = json["voteToken"].string {
            print(voteToken)
        }
        
    }

}