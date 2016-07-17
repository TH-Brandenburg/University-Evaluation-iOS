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
    var deviceID: String = ""
    
    @IBAction func submit(sender: UIButton) {
        var complete = true;
        for mcAnswer in answersDTO.mcAnswers{
            if mcAnswer.choice == nil {
                complete = false
                break
            }
        }
        
        if answersDTO.studyPath == nil {
        
            let alertController = UIAlertController(title: "Studiengang", message:
            "Bitte wählen Sie Ihren Studiengang.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .Default,handler: {_ in
                //Navigate to study path selection
                (self.parentViewController?.parentViewController as! RootViewController).pickerView.selectItem(0, animated: true)
            }))
        
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
            
        }
        
        if complete {
            (self.parentViewController?.parentViewController as? RootViewController)?.performSegueWithIdentifier("submit", sender: self)
        } else {
            let alertController = UIAlertController(title: "Wirklich absenden?", message:
                "Sie haben noch nicht alle Fragen beantwortet.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Trotzdem absenden", style: .Destructive,handler: self.submitAnyway))
            alertController.addAction(UIAlertAction(title: "Fehlende Fragen beantworten", style: .Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func submitAnyway(action: UIAlertAction){
        for mcAnswer in answersDTO.mcAnswers{
            if mcAnswer.choice == nil {
                answersDTO.mcAnswers.removeAtIndex(answersDTO.mcAnswers.indexOf(mcAnswer)!)
            }
        }
        (self.parentViewController?.parentViewController as? RootViewController)?.performSegueWithIdentifier("submit", sender: self)
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
