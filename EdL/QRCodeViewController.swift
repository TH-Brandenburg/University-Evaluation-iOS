//
//  ViewController.swift
//  THBEval
//
//  Created by Patrick Wilhelm on 16/06/16.
//

import UIKit
import AVFoundation
import SwiftyJSON
import Alamofire
import AudioToolbox

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var responseData: JSON!
    var userData: JSON!
    var deviceID: String = ""
    var host: String = ""
    var voteToken: String = ""
    var qrCodeContent: String = ""
    
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    
    // Locking view to Portrait-Mode
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    //MARK:- CAMERA ACCESS CHECK
    func cameraAllowsAccessToApplicationCheck()
    {
        captureSession?.startRunning()
        messageLabel.text = "Bitte QR-Code scannen"
        messageLabel.textColor = UIColor.whiteColor()
        let authorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch authorizationStatus {
        case .NotDetermined:
            // permission dialog not yet presented, request authorization
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler:
                { (granted:Bool) -> Void in
                    if granted {
                        print("access granted")
                    }
                    else {
                        print("access denied")
                        let alertView = UIAlertController(title: "Kein Kamerazugriff möglich", message: "Bitte lassen Sie den Kamerazugriff in den Einstellungen zu. Dieser wird benötigt, um den QR-Code einzulesen", preferredStyle: .Alert)
                        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alertView, animated: true, completion: nil)
                    }
            })
        case .Authorized:
            print("Access authorized")
        case .Denied, .Restricted:
            let alertView = UIAlertController(title: "Kein Kamerazugriff möglich", message: "Bitte lassen Sie den Kamerazugriff in den Einstellungen zu. Dieser wird benötigt, um den QR-Code einzulesen", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        
        do {
            let input: AnyObject! = try AVCaptureDeviceInput(device: captureDevice)
            
            messageLabel.backgroundColor = UIColor.clearColor()
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input as! AVCaptureInput)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Move the message label to the top view
            view.bringSubviewToFront(blurEffectView)
            view.bringSubviewToFront(messageLabel)
            
        } catch let error as NSError{
            // If any error occurs, simply log the description of it and don't continue any more.
            print("\(error.localizedDescription)")
            return
        }
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.backgroundColor = UIColor.clearColor()
            messageLabel.text = "Kein QR-Code erkannt"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
            }
            let jsonStringData = metadataObj.stringValue
            //Convert String to NSString
            let jsonNSStringData = jsonStringData as NSString!
            
            //Convert NSString to NSData
            let data = jsonNSStringData.dataUsingEncoding(NSUTF8StringEncoding)!
            
            // Validating JSON
            let json = JSON(data: data)
            var hostBool:Bool = false
            var voteTokenBool:Bool = false
            
            if json["host"].string != nil {
                hostBool = true
            }
            if json["voteToken"].string != nil {
                voteTokenBool = true
            }
            
            if (voteTokenBool && hostBool){
                host = json["host"].string!
                voteToken = json["voteToken"].string!
                deviceID = UIDevice.currentDevice().identifierForVendor!.UUIDString
                userData = ["deviceID": deviceID, "voteToken": voteToken]
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                sendRequest(host, voteToken: voteToken, deviceID: deviceID)
                messageLabel.textColor = UIColor.clearColor()
                qrCodeFrameView?.frame = CGRectZero
                captureSession?.stopRunning()
            } else {
                messageLabel.text = "Kein valider QR-Code"
                let redAlpha = UIColor.redColor()
                messageLabel.backgroundColor = redAlpha.colorWithAlphaComponent(0.3)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "afterScan") {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            //print(self.responseObj)
            let detailVC = segue.destinationViewController as! RootViewController;
            detailVC.questionData = self.responseData
            detailVC.userData = self.userData
            print(userData)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraAllowsAccessToApplicationCheck()
    }
    
    func sendRequest(host:String, voteToken:String, deviceID:String) {
        let request = NSMutableURLRequest(URL: NSURL(string: host + "/v1/questions")!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody = ["voteToken": voteToken, "host": host, "deviceID": deviceID]
        
        print(jsonBody)
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: [])
        
        Alamofire.request(request)
            .validate()
            .responseJSON { response in
                // do whatever you want here
                switch response.result {
                case .Failure(let error):
                    print(response.response?.statusCode)
                    print("Request failed with error: \(error)")
                    //print("RESULT" + String(response.result))
                    if(response.response?.statusCode >= 400) {
                        let alertView = UIAlertController(title: "Falscher QR Code", message: "Bitte überprüfen, ob der QR Code nicht bereits genutzt wurde.", preferredStyle: .Alert)
                        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {_ in
                            self.captureSession?.startRunning()
                            self.messageLabel.textColor = UIColor.whiteColor()
                            self.messageLabel.text = "Bitte QR-Code scannen"
                        }))
                        self.presentViewController(alertView, animated: true, completion: nil)
                        // handle 409 specific error here, if you want
                        //print("Request failed with error: \(error)")
                        //print("Test")
                    } else { if let errorCode = response.result.error?.code {
                        switch(errorCode) {
                        case -1001:
                            let alertView = UIAlertController(title: "Fehler", message: "Server ist zurzeit nicht erreichbar.", preferredStyle: .Alert)
                            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {_ in
                                self.captureSession?.startRunning()
                                self.messageLabel.textColor = UIColor.whiteColor()
                                self.messageLabel.text = "Bitte QR-Code scannen"}))
                            self.presentViewController(alertView, animated: true, completion: nil)
                        case -1004:
                            let alertView = UIAlertController(title: "Fehler", message: "Server ist zurzeit nicht erreichbar.", preferredStyle: .Alert)
                            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {_ in
                                self.captureSession?.startRunning()
                                self.messageLabel.textColor = UIColor.whiteColor()
                                self.messageLabel.text = "Bitte QR-Code scannen"}))
                            self.presentViewController(alertView, animated: true, completion: nil)
                        default:
                            let alertView = UIAlertController(title: "Fehler", message: "Server ist zurzeit nicht erreichbar.", preferredStyle: .Alert)
                            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {_ in
                                self.captureSession?.startRunning()
                                self.messageLabel.textColor = UIColor.whiteColor()
                                self.messageLabel.text = "Bitte QR-Code scannen"}))
                        }
                        }
                    } //else if(response.result.error?.code == -100)
                    
                case .Success:
                    //print(responseObject)
                    if let value = response.result.value{
                        self.responseData = JSON(value)
                        print("responseData: \(self.responseData)")
                        self.performSegueWithIdentifier("afterScan", sender: nil)
                    }
                }
                
        }
    }
}