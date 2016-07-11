//
//  RootViewController.swift
//  EdL
//
//  Created by Daniel Weis on 18.06.16.
//
//

import UIKit
import SwiftyJSON
import AKPickerView_Swift

class RootViewController: UIViewController, UIGestureRecognizerDelegate, UIPageViewControllerDelegate, AKPickerViewDelegate {

    
    @IBOutlet weak var pageViewControllerContainer: UIView!
    @IBOutlet weak var pickerView: AKPickerView!
    
    var questions: QuestionsDTO!
    var answers: AnswersDTO!
    
    var userData: JSON!
    var questionData: JSON!
    var host: String = ""
    
    
    var previousIndex: Int = 0
    
    var questionPageViewController: QuestionPageViewController!
    
    override func loadView() {
        super.loadView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.questions = Helper.parseJSON(self.questionData)
        self.answers = Helper.createAnswersDTO(self.questions, voteToken: userData["voteToken"].string!, deviceID: userData["deviceID"].string!)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.pickerView.delegate = self
        self.pickerView.dataSource = self.modelController
        
        self.pickerView.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        self.pickerView.highlightedFont = UIFont(name: "HelveticaNeue", size: 20)!
        self.pickerView.pickerViewStyle = .Flat
        self.pickerView.interitemSpacing = 0.5
        self.pickerView.maskDisabled = true
        self.pickerView.reloadData()
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: 0, width:  pickerView.frame.size.width, height: pickerView.frame.size.height)
        
        border.borderWidth = width
        pickerView.layer.addSublayer(border)
        pickerView.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var modelController: QuestionController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = QuestionController(questions: self.questions, answers: self.answers)
        }
        return _modelController!
    }

    var _modelController: QuestionController? = nil
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedQuestionPageViewController"{
            let embedVC = segue.destinationViewController as! QuestionPageViewController
            embedVC.delegate = self
            embedVC.dataSource = self.modelController
            let startingViewController: UIViewController = self.modelController.viewControllerAtIndex(0, storyboard: UIStoryboard(name: "Questions", bundle: nil))!
            let viewControllers = [startingViewController]
            embedVC.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
            self.questionPageViewController = embedVC
        }
    }
    
    // MARK: - AKPicker
    func pickerView(pickerView: AKPickerView, configureLabel label: UILabel, forItem item: Int) {
        label.textColor = UIColor.darkGrayColor()
        label.highlightedTextColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.lightGrayColor()
    }
    
    func pickerView(pickerView: AKPickerView, marginForItem item: Int) -> CGSize {
        return CGSizeMake(30, 20)
    }
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        if item != previousIndex{
            let nextViewController = self.modelController.viewControllerAtIndex(item, storyboard: UIStoryboard(name: "Questions", bundle: nil))!
            let viewControllers = [nextViewController]
            self.questionPageViewController.setViewControllers(viewControllers, direction: item < previousIndex ? .Reverse : .Forward, animated: true, completion: {done in })
            previousIndex = item
        }
        
    }
    
    func updateViewPicker(index: Int) {
        if previousIndex != index {
            self.previousIndex = index
            self.pickerView.selectItem(index, animated: true)

        }
    }
    
    // MARK: - PageViewController Delegate
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let pendingIndex = self.modelController.getIndex(pendingViewControllers[0])
        self.updateViewPicker(pendingIndex)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let index = self.modelController.getIndex(pageViewController.viewControllers![0])
        self.updateViewPicker(index)
    }
    
    // MARK: - Navigation
    
    // Disable Back gesture
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    

}

