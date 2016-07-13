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
        
        var textQuestionIDs: [Int] = []
        for textAnswer in answersDTO.textAnswers{
            textQuestionIDs.append(textAnswer.questionID)
        }
        
        let images = Helper.zipImages()
        
        if images != nil {
            Alamofire.upload(.POST, "\((self.parentViewController!.parentViewController as! RootViewController).host)/v1/answers",
                             multipartFormData: { multipartFormData in
                                multipartFormData.appendBodyPart(data: answers.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!,
                                    name: "answers-dto",
                                    mimeType: "text/plain; charset=UTF-8")
                                multipartFormData.appendBodyPart(data: images!, name: "images",
                                    fileName: "images.zip",
                                    mimeType: "multipart/form-data")
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
        }
        
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
