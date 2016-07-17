//
//  SubmitViewController.swift
//  EdL
//
//  Created by Daniel Weis on 17.07.16.
//
//

import UIKit
import Alamofire

class SubmitViewController: UIViewController {
    
    var answersDTO: AnswersDTO!
    var host: String!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var successLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.submit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submit(){
        print("Answers:\n\(answersDTO.toJsonString())")
        let answers = answersDTO.toJsonString()
        
        let images = Helper.zipImages()
        
        if images != nil {
            Alamofire.upload(.POST, "\(self.host)/v1/answers",
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
                                    self.successLabel?.hidden = false
                                    self.activityIndicator?.stopAnimating()
                                case .Failure(let encodingError):
                                    print(encodingError)
                                }
                }
            )
        }

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
