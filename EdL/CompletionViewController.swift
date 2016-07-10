//
//  CompletionViewController.swift
//  EdL
//
//  Created by Daniel Weis on 09.07.16.
//
//

import UIKit

class CompletionViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    
    var answersDTO: AnswersDTO!
    var index: Int = -1
    
    
    @IBAction func submit(sender: UIButton) {
        print("Answers:\n\(answersDTO.toJsonString())")
        //performSegueWithIdentifier("submit", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "submit" {
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
