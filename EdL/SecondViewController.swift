//
//  SecondViewController.swift
//  THBEval
//
//  Created by Patrick on 19.06.16.
//  Copyright © 2016 THB. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SecondViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var messageLabel: UILabel!
    
    var toPass: String!
    var responseObj: AnyObject!
    
    
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
        let host = json["host"].string
        
        print(host)
        
        //Request an Server zur Abfrage der Fragen
        let request = NSMutableURLRequest(URL: NSURL(string: host! + "/v1/questions")!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody = ["voteToken": json["voteToken"].string!, "host": json["host"].string!, "deviceID": 1234]
        
        print(jsonBody)
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: [])
        
        Alamofire.request(request)
            .responseJSON { response in
                // do whatever you want here
                switch response.result {
                case .Failure(let error):
                    print(error)
                case .Success(let responseObject):
                    print(responseObject)
                    self.responseObj = responseObject
                    //let responseObj = responseObject
                    self.performSegueWithIdentifier("afterReq", sender: nil)
                    
                }
                
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "afterReq") {
            
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destinationViewController as! QuestionViewController
            destinationVC.toPass = self.responseObj
        }
    }
}
