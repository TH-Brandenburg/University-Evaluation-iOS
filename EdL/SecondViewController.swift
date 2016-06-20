//
//  SecondViewController.swift
//  THBEval
//
//  Created by Patrick on 19.06.16.
//  Copyright © 2016 THB. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var messageLabel: UILabel!
    
    var toPass: String!
    
    
    // Locking view to Portrait-Mode
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewDidLoad() {
        print(toPass)
        
    }

}