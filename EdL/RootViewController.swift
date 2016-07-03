//
//  RootViewController.swift
//  EdL
//
//  Created by Daniel Weis on 18.06.16.
//
//

import UIKit
import SwiftyJSON

class RootViewController: UIViewController, UIPageViewControllerDelegate {

    
    @IBOutlet weak var pageViewControllerContainer: UIView!
    
    var pageViewController: UIPageViewController?
    
    var questions: QuestionsDTO!
    var answers: AnswersDTO!
    
    override func loadView() {
        super.loadView()
        
        //Load json with test data from file
        let path = NSBundle.mainBundle().pathForResource("response.json", ofType: nil)
        
        var fileContents: String? = nil
        do {
            fileContents = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        } catch _ as NSError {
            print("Can't open response.json")
        }
        
        let data: JSON
        
        if let dataFromString = fileContents!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            data = JSON(data: dataFromString)
            self.questions = Helper.parseJSON(data)
            self.answers = Helper.createAnswersDTO(self.questions, voteToken: "token", deviceID: "id")
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        }
    }

    // MARK: - UIPageViewController delegate methods

    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        if (orientation == .Portrait) || (orientation == .PortraitUpsideDown) || (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
            let currentViewController = pageViewController.viewControllers![0]
            let viewControllers = [currentViewController]
            pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })

            pageViewController.doubleSided = false
            return .Min
        }
        return .Min

        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        /*let currentViewController = self.pageViewController!.viewControllers![0] as! DataViewController
        var viewControllers: [UIViewController]

        let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
            let nextViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfterViewController: currentViewController)
            viewControllers = [currentViewController, nextViewController!]
        } else {
            let previousViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBeforeViewController: currentViewController)
            viewControllers = [previousViewController!, currentViewController]
        }
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })

        return .Mid*/
    }
    

}

