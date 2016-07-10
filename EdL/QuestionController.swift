//
//  QuestionController.swift
//  EdL
//
//  Created by Daniel Weis on 18.06.16.
//
//

import UIKit
import SwiftyJSON
import AKPickerView_Swift

/// This class controls the PageViewController and creates ViewControllers for each question
class QuestionController: NSObject, UIPageViewControllerDataSource, AKPickerViewDataSource {

    var questions: QuestionsDTO
    var answers: AnswersDTO
    
    let otherPagesCount = 2
    
    enum QuestionType {
        case MultipleChoice
        case Text
        case StudyPath
        case Completion
    }
    
    init(questions: QuestionsDTO, answers: AnswersDTO) {
        self.questions = questions
        self.answers = answers
        super.init()
    }
    
    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> UIViewController? {
        // Return the data view controller for the given index.
        // Create a new view controller and pass suitable data.
        
        if index == 0 {
            return createViewController(.StudyPath, index: index, localIndex: index, storyboard: storyboard)
        } else if index == questions.textQuestions.count + questions.multipleChoiceQuestions.count + otherPagesCount - 1 {
            return createViewController(.Completion, index: index, localIndex: index, storyboard: storyboard)
        } else if questions.textQuestionsFirst {
            if index < questions.textQuestions.count + 1 {
                return createViewController(.Text, index: index, localIndex: index - 1, storyboard: storyboard)
            } else {
                return createViewController(.MultipleChoice, index: index, localIndex: index - questions.textQuestions.count - 1, storyboard: storyboard)
            }
        } else {
            if index < questions.multipleChoiceQuestions.count + 1 {
                return createViewController(.MultipleChoice, index: index, localIndex: index - 1, storyboard: storyboard)
            } else {
                return createViewController(.Text, index: index, localIndex: index - questions.multipleChoiceQuestions.count - 1, storyboard: storyboard)
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
        } else if type == .StudyPath{
            let studyPathViewController = storyboard.instantiateViewControllerWithIdentifier("StudyPath") as! StudyPathViewController
            studyPathViewController.studyPaths = questions.studyPaths
            studyPathViewController.answersDTO = answers
            studyPathViewController.index = index
            return studyPathViewController
        } else if type == .Completion{
            let completionViewController = storyboard.instantiateViewControllerWithIdentifier("Completion") as! CompletionViewController
            completionViewController.answersDTO = answers
            completionViewController.index = index
            return completionViewController
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
        
        if let questionViewController = viewController as? StudyPathViewController{
            return questionViewController.index
        }
        
        if let questionViewController = viewController as? CompletionViewController{
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
        
        if index == questions.multipleChoiceQuestions.count + questions.textQuestions.count + self.otherPagesCount {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    // MARK: - AKPickerViewDataSource
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return self.questions.multipleChoiceQuestions.count + self.questions.textQuestions.count + self.otherPagesCount
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        if item == 0 {
            return "Studiengang"
        }
        if item == self.numberOfItemsInPickerView(pickerView) - 1 {
            return "Absenden"
        }
        
        return String(item)
    }
    
    
    
}
