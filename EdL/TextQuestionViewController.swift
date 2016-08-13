//
//  TextQuestionViewController.swift
//  EdL
//
//  Created by Daniel Weis on 19.06.16.
//
//

import UIKit
import ImageViewer



class TextQuestionViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageProvider {
    
    var questionDTO: TextQuestionDTO!
    var answerDTO: TextAnswerDTO!
    var index: Int = -1
    var localIndex: Int = -1
    
    var imagePicker: UIImagePickerController!
    
    var subscribedToKeyboardNotifications = false {
        willSet(newValue) {
            if newValue && !subscribedToKeyboardNotifications {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TextQuestionViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TextQuestionViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
            } else if !newValue && subscribedToKeyboardNotifications {
                NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
                NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
            }
        }
    }
    
    let bottomNavigationHeight = 50
    var textFieldOffsetWithoutNavigationBar = 0
    var textFieldOffset = false;
    
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var imageStackView: UIStackView!
    
    
    
    func takePhoto(sender: UIBarButtonItem) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func showPhoto(sender: UIButton) {
        
        let buttonAssets = CloseButtonAssets(normal: UIImage(named:"ic_close_white")!, highlighted: UIImage(named: "ic_close_white")!)
        let configuration = ImageViewerConfiguration(imageSize: CGSize(width: 10, height: 10), closeButtonAssets: buttonAssets)
        
        let imageViewer = ImageViewer(imageProvider: self, configuration: configuration, displacedView: sender)
        self.presentImageViewer(imageViewer)
        
        
    }
    
    @IBAction func deletePhoto(sender: UIButton) {
        let fileMgr = NSFileManager()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let dataPath = documentsPath.stringByAppendingPathComponent("images")
        let imagePath = "\(dataPath)/\(answerDTO.questionID).jpg"
        let thumbnailsPath = documentsPath.stringByAppendingPathComponent("thumbnails")
        let thumbnailPath = "\(thumbnailsPath)/\(answerDTO.questionID).jpg"

        _ = try? fileMgr.removeItemAtPath(imagePath)
        _ = try? fileMgr.removeItemAtPath(thumbnailPath)
        
        self.imageButton.setImage(nil, forState: .Normal)
        loadPhoto()

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        subscribedToKeyboardNotifications = true //refer to setter
        
        //Question Text
        if let questionTextView = self.view.viewWithTag(10) as? UITextView{
            questionTextView.text = questionDTO.questionText
            questionTextView.selectable = false // set to true in storyboard and changed back here to fix font size
        }
        
        self.loadPhoto()
        
        if let answerTextView = self.view.viewWithTag(20) as? UITextView{
            answerTextView.layer.cornerRadius = 5
            answerTextView.layer.borderColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1).CGColor
            answerTextView.layer.borderWidth = 1
            answerTextView.delegate = self
            if answerDTO.answerText != ""{
                answerTextView.text = answerDTO.answerText
            } else {
                answerTextView.text = "Antwort eingeben..."
                answerTextView.textColor = UIColor.lightGrayColor()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let camera = UIBarButtonItem(barButtonSystemItem: .Camera,
                                     target: self,
                                     action: #selector(self.takePhoto(_:))
        )
        parentViewController!.parentViewController!.navigationItem.rightBarButtonItem = camera
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Remove NavBarButton for Camera, if exists
        if ((parentViewController?.parentViewController?.navigationItem) != nil){
            parentViewController!.parentViewController!.navigationItem.rightBarButtonItem = nil
        }
        
        subscribedToKeyboardNotifications = false //refer to setter
        

    }
    
    // MARK: - Text View Delegate
    
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
    
    // MARK: - Image Picker View Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)

        let image1000 = Helper.resizeImage(image, newWidth: 1000)
        let data = UIImageJPEGRepresentation(image1000, 0.8)
        
        let image150 = Helper.resizeImage(image, newWidth: 150)
        let thumbData = UIImageJPEGRepresentation(image150, 0.8)
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
            let dataPath = documentsPath.stringByAppendingPathComponent("images")
            let thumbnailPath = documentsPath.stringByAppendingPathComponent("thumbnails")

            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(thumbnailPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
            try data?.writeToFile("\(dataPath)/\(answerDTO.questionID).jpg", options: .DataWritingAtomic)
            try thumbData?.writeToFile("\(thumbnailPath)/\(answerDTO.questionID).jpg", options: .DataWritingAtomic)
            
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        print("Saved image!")
        self.loadPhoto()
    }
    
    func loadPhoto(){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let thumbnailPath = documentsPath.stringByAppendingPathComponent("thumbnails")
        let imagePath = "\(thumbnailPath)/\(answerDTO.questionID).jpg"
        let image = UIImage(contentsOfFile: imagePath)
        if image != nil {
            self.imageButton.setImage(image, forState: .Normal)
            self.imageButton.imageView?.contentMode = .ScaleAspectFit
            self.imageStackView.hidden = false
        } else {
            self.imageStackView.hidden = true
        }
    }
    
    // MARK: - ImageProvider
    
    func provideImage(completion: UIImage? -> Void){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let imagesPath = documentsPath.stringByAppendingPathComponent("images")
        let imagePath = "\(imagesPath)/\(answerDTO.questionID).jpg"
        let image = UIImage(contentsOfFile: imagePath)
        completion(image)
    }
    
    func provideImage(atIndex index: Int, completion: UIImage? -> Void) {
        //not implemented, but required by ImageProvider protocol
        completion(nil)
    }
    
    // MARK: - Keyboard related behavior
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            if textFieldOffset{
                self.view.frame.origin.y -= keyboardSize.height - CGFloat(self.textFieldOffsetWithoutNavigationBar)
            } else {
                self.view.frame.origin.y -= keyboardSize.height - CGFloat(self.bottomNavigationHeight) - CGFloat(self.textFieldOffsetWithoutNavigationBar)
            }
            
            self.textFieldOffsetWithoutNavigationBar = Int(keyboardSize.height)
            self.textFieldOffset = true
        }
        for view in self.parentViewController!.view.subviews {
            if let subView = view as? UIScrollView {
                subView.scrollEnabled = false
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            
            if textFieldOffset{
                if keyboardSize.height == CGFloat(self.textFieldOffsetWithoutNavigationBar){
                    self.view.frame.origin.y += keyboardSize.height - CGFloat(self.bottomNavigationHeight)
                    self.textFieldOffsetWithoutNavigationBar = 0
                    textFieldOffset = false
                } else {
                    self.view.frame.origin.y += CGFloat(self.textFieldOffsetWithoutNavigationBar) - keyboardSize.height
                    self.textFieldOffsetWithoutNavigationBar = Int(keyboardSize.height)
                }
            }
            
        }
        for view in self.parentViewController!.view.subviews {
            if let subView = view as? UIScrollView {
                subView.scrollEnabled = true
            }
        }
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
