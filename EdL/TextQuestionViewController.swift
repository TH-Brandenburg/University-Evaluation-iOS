//
//  TextQuestionViewController.swift
//  EdL
//
//  Created by Daniel Weis on 19.06.16.
//
//

import UIKit

class TextQuestionViewController: UIViewController, UITextViewDelegate {
    
    var questionDTO: TextQuestionDTO!
    var answerDTO: TextAnswerDTO!
    var index: Int = -1
    var localIndex: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Question Text
        if let questionTextView = self.view.viewWithTag(10) as? UITextView{
            questionTextView.text = questionDTO.questionText
            questionTextView.selectable = false // set to true in storyboard and changed back here to fix font size
        }
        
        if let answerTextView = self.view.viewWithTag(20) as? UITextView{
            answerTextView.layer.cornerRadius = 5
            answerTextView.layer.borderColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1).CGColor
            answerTextView.layer.borderWidth = 1
            answerTextView.delegate = self
            if let answerText: String = answerDTO.answerText{
                answerTextView.text = answerText
            } else {
                answerTextView.text = "Antwort eingeben..."
                answerTextView.textColor = UIColor.lightGrayColor()
            }
        }
    }
    
    // MARK: - Test View Delegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Antwort eingeben..." {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        answerDTO.answerText = textView.text
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
