//
//  MultipleChoiceQuestionViewController.swift
//  EdL
//
//  Created by Daniel Weis on 18.06.16.
//
//

import UIKit
import SwiftyJSON

class MultipleChoiceQuestionViewController: UIViewController {
    
    var questionDTO: MultipleChoiceQuestionDTO!
    var answerDTO: MultipleChoiceAnswerDTO!
    var index: Int = -1
    var localIndex: Int = -1
    var buttons: [UIButton] = []
    
    @IBAction func selectAnswer(sender: UIButton) {
        for button in buttons{
            if button == sender && !button.selected{
                button.selected = true
                button.layer.backgroundColor = button.layer.borderColor
                if let btnIndex = buttons.indexOf(button){
                    answerDTO.choice = questionDTO.choices[btnIndex]
                    print("Choice: \(answerDTO.choice!.choiceText)")
                }
            } else {
                button.selected = false
                button.layer.backgroundColor = UIColor.whiteColor().CGColor
                if button == sender{
                    answerDTO.choice = nil
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Question Text
        if let questionTextView = self.view.viewWithTag(10) as? UITextView{
            questionTextView.text = questionDTO.question
            questionTextView.selectable = false // true in storyboard to fix font size
        }
        
        //Buttons
        for i in 0..<questionDTO.choices.count {
            if let button = self.view.viewWithTag(20 + i) as? UIButton{
                button.setTitle(questionDTO.choices[i].choiceText, forState: .Normal)
                button.layer.cornerRadius = 5
                button.layer.borderColor = Colors.grades[questionDTO.choices[i].grade].CGColor
                button.layer.borderWidth = 1
                buttons.append(button)
            }
        }
        
        if let choice = answerDTO.choice{
            if let choiceIndex = questionDTO.choices.indexOf({$0 === choice}){
                buttons[choiceIndex].selected = true
                buttons[choiceIndex].layer.backgroundColor = buttons[choiceIndex].layer.borderColor
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //super.viewWillAppear(animated)
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
