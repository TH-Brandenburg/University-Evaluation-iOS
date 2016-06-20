//
//  QuestionController.swift
//  EdL
//
//  Created by Daniel Weis on 18.06.16.
//
//

import UIKit
import SwiftyJSON

/// This class controls the PageViewController and creates ViewControllers for each question
class QuestionController: NSObject, UIPageViewControllerDataSource {

    var questions: QuestionsDTO
    var answers: AnswersDTO
    
    enum QuestionType {
        case MultipleChoice
        case Text
    }
    
    init(questions: QuestionsDTO, answers: AnswersDTO) {
        self.questions = questions
        self.answers = answers
        super.init()
    }
    
    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> UIViewController? {
        // Return the data view controller for the given index.       
        // Create a new view controller and pass suitable data.
        
        if questions.textQuestionsFirst{
            if index < questions.textQuestions.count{
                return createViewController(.Text, index: index, localIndex: index, storyboard: storyboard)
            } else {
                return createViewController(.MultipleChoice, index: index, localIndex: index - questions.textQuestions.count, storyboard: storyboard)
            }
        } else {
            if index < questions.multipleChoiceQuestions.count{
                return createViewController(.MultipleChoice, index: index, localIndex: index, storyboard: storyboard)
            } else {
                return createViewController(.Text, index: index, localIndex: index - questions.multipleChoiceQuestions.count, storyboard: storyboard)
            }
        }
    }
    
    func createViewController(type: QuestionType, index: Int, localIndex: Int, storyboard: UIStoryboard) -> UIViewController? {
        if type == .MultipleChoice{
            let mcQuestionViewController = storyboard.instantiateViewControllerWithIdentifier("5Buttons") as! MultipleChoiceQuestionViewController
            mcQuestionViewController.questionDTO = questions.multipleChoiceQuestions[localIndex]
            mcQuestionViewController.answerDTO = answers.mcAnswers[localIndex]
            mcQuestionViewController.index = index
            mcQuestionViewController.localIndex = localIndex
            return mcQuestionViewController
        } else if type == .Text{
            let textQuestionViewController = storyboard.instantiateViewControllerWithIdentifier("TextQuestion") as! TextQuestionViewController
            textQuestionViewController.questionDTO = questions.textQuestions[localIndex]
            textQuestionViewController.answerDTO = answers.textAnswers[localIndex]
            textQuestionViewController.index = index
            textQuestionViewController.localIndex = localIndex
            return textQuestionViewController
        }
        return nil
    }
    
    func getIndex(viewController: UIViewController) -> Int {
        
        if let questionViewController = viewController as? TextQuestionViewController{
            return questionViewController.index
        }

        if let questionViewController = viewController as? MultipleChoiceQuestionViewController{
            return questionViewController.index
        }
        
        return -1
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = getIndex(viewController)
        if (index == 0) || (index == -1) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = getIndex(viewController)
        if index == -1 {
            return nil
        }
        
        index += 1
        
        if index == questions.multipleChoiceQuestions.count + questions.textQuestions.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
}
