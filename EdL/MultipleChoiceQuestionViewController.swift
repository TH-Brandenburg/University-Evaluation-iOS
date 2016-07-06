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
                if let btnIndex = buttons.indexOf(button){
                    button.layer.backgroundColor = Colors.grades[abs(questionDTO.choices[btnIndex].grade)].CGColor
                    answerDTO.choice = questionDTO.choices[btnIndex]
                    print("Choice: \(answerDTO.choice!.choiceText)")
                }
            } else {
                button.selected = false
                if let btnIndex = buttons.indexOf(button){
                    button.layer.backgroundColor = Colors.gradesLight[abs(questionDTO.choices[btnIndex].grade)].CGColor
                }
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
                button.layer.backgroundColor = Colors.gradesLight[abs(questionDTO.choices[i].grade)].CGColor
                buttons.append(button)
            }
        }
        
        if let choice = answerDTO.choice{
            if let choiceIndex = questionDTO.choices.indexOf({$0 === choice}){
                buttons[choiceIndex].selected = true
                buttons[choiceIndex].layer.backgroundColor = Colors.grades[abs(questionDTO.choices[choiceIndex].grade)].CGColor
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
