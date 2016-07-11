//
//  CompletionViewController.swift
//  EdL
//
//  Created by Daniel Weis on 09.07.16.
//
//

import UIKit
import SwiftyJSON
import Alamofire

class CompletionViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    
    var answersDTO: AnswersDTO!
    var responseData: JSON!
    var index: Int = -1
    var deviceID: String = ""
    
    @IBAction func submit(sender: UIButton) {
        print("Answers:\n\(answersDTO.toJsonString())")
        let answers = answersDTO.toJsonString()
        //let answersJSON = JSON(answers)
//        let request = NSMutableURLRequest(URL: NSURL(string: "http://172.20.214.195:8080/v1/answers")!)
//        request.HTTPMethod = "POST"
//        request.setValue("application/", forHTTPHeaderField: "Content-Type")
//            
//        let jsonBody = ["answers-dto": answers]
//        
//        print(jsonBody)
//        print()
//        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: [])
        
//        Alamofire.request(.POST, "http://172.20.214.195:8080/v1/answers", parameters: ["answers-dto": answers])
//            .validate()
//            .responseJSON { response in
//                // do whatever you want here
//                switch response.result {
//                case .Failure(let error):
//                    print(response.response?.statusCode)
//                    print("Request failed with error: \(error)")
//                    //print("RESULT" + String(response.result))
//                case .Success:
//                    //print(responseObject)
//                    if let value = response.result.value{
//                        self.responseData = JSON(value)
//                        print("responseData: \(self.responseData)")
//                        self.performSegueWithIdentifier("submit", sender: nil)
//                    }
//                }
//                    
//        }
        Alamofire.upload(.POST, "http://172.20.214.195:8080/v1/answers",
                    multipartFormData: { multipartFormData in
                        multipartFormData.appendBodyPart(data: answers.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"answers-dto")
                        multipartFormData.appendBodyPart(data: NSData(), name :"images")
                    },
                          encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .Success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                }
                            case .Failure(let encodingError):
                                print(encodingError)
                            }
            }
        )
//        .responseJSON { response in
//                // do whatever you want here
//                switch response.result {
//                case .Failure(let error):
//                    print(response.response?.statusCode)
//                    print("Request failed with error: \(error)")
//                //print("RESULT" + String(response.result))
//                case .Success:
//                    //print(responseObject)
//                    if let value = response.result.value{
//                        self.responseData = JSON(value)
//                        print("responseData: \(self.responseData)")
//                        self.performSegueWithIdentifier("submit", sender: nil)
//                    }
//                }
//                
//        }
    }

    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "submit" {
            print(responseData)
            //let submitVC = segue.destinationViewController as! SubmitViewController
            //submitVC.jsonString = answersDTO.toJsonString()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = 5
        submitButton.layer.backgroundColor = Colors.blue.CGColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
