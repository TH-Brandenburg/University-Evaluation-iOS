//
//  StudyPathViewController.swift
//  EdL
//
//  Created by Daniel Weis on 09.07.16.
//
//

import UIKit

class StudyPathViewController: UIViewController {
    
    var studyPaths: [String]!
    var answersDTO: AnswersDTO!
    var index: Int = -1
    var buttons: [UIButton] = []
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    func selectAnswer(sender: UIButton!){
        for button in buttons{
            if button == sender && !button.selected{
                button.selected = true
                button.layer.backgroundColor = Colors.grades[1].CGColor
                answersDTO.studyPath = button.titleLabel?.text
                print(answersDTO.studyPath)
            } else {
                button.selected = false
                button.layer.backgroundColor = Colors.gradesLight[1].CGColor
                if button == sender{
                    answersDTO.studyPath = nil
                }
            }
        }

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for studyPath in studyPaths{
            let button = UIButton(type: .Custom)
            //button.frame = CGRect(x: 0, y: 0, width: 300, height: 45)
            button.setTitle(studyPath, forState: .Normal)
            let heightConstraint = button.heightAnchor.constraintEqualToAnchor(nil, multiplier: 1, constant: 45)
            let widthConstraint = button.widthAnchor.constraintEqualToAnchor(nil, multiplier: 1, constant: 300)
            NSLayoutConstraint.activateConstraints([heightConstraint, widthConstraint])
            
            button.layer.cornerRadius = 5
            button.layer.backgroundColor = Colors.gradesLight[1].CGColor
            button.setTitleColor(Colors.blue, forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            
            button.addTarget(self, action: #selector(selectAnswer), forControlEvents: .TouchUpInside)
            
            if answersDTO.studyPath == studyPath{
                button.selected = true
                button.layer.backgroundColor = Colors.grades[1].CGColor
                
            }
            
            buttonStackView.addArrangedSubview(button)
            buttons.append(button)
        }
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
