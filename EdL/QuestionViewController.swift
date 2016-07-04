import UIKit
import SwiftyJSON

class QuestionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var messageLabel: UILabel!
    
    var toPass: AnyObject!
    
    // Locking view to Portrait-Mode
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    //Test ob JSON Objekt vorhanden ist
    override func viewDidLoad() {
        print(toPass)
    }
}
