//
//  ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 5/28/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import Stormpath

class ViewController: UIViewController {
 
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    
    let nodeUrl = "http://54.201.210.104"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print(Stormpath.sharedSession)
        
        Stormpath.sharedSession.me { (account, error) -> Void in
            if let account = account {
                self.errorLabel.text = "Hello \(account.fullName)!"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInBtn.backgroundColor = UIColor(red: 23.0/225.0, green: 145.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setBottomBorder(usernameTextfield)
        setBottomBorder(passwordTextfield)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    private func setBottomBorder(textfield: UITextField) {
        let border = CALayer()
        let width = CGFloat(2.0)
        let borderColor = UIColor.darkGrayColor().CGColor
        
        border.borderColor = borderColor
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: textfield.frame.size.height, width:  textfield.frame.size.width, height: 1)
        
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
    }
    
    @IBAction func login(sender: AnyObject) {
        Stormpath.sharedSession.login(usernameTextfield.text!, password: passwordTextfield.text!, completionHandler: logResponse)
    }
    
    func logResponse(success: Bool, error: NSError?) {
        if let error = error {
//            showAlert(withTitle: "Error", message: error.localizedDescription)
            self.errorLabel.text = error.localizedDescription
        }
        else {
//            showAlert(withTitle: "Success", message: "You logged in successfully")
            
            Stormpath.sharedSession.me { (account, error) -> Void in
                if let account = account {
                    self.errorLabel.text = "Hello \(account.fullName)!"
                }
            }
            
            let notesEndpoint = NSURL(string: nodeUrl + "/secret")!
            let request = NSMutableURLRequest(URL: notesEndpoint)
            request.setValue("Bearer \(Stormpath.sharedSession.accessToken!)", forHTTPHeaderField: "Authorization")
//            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
//                guard let data = data, json = try? NSJSONSerialization.JSONObjectWithData(data, options: []), notes = json["notes"] as? String else {
//                    return
//                }
//                dispatch_async(dispatch_get_main_queue(), {
////                    self.notesTextView.text = notes
//                    
//                })
//            }
//            task.resume()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let secondViewController = storyBoard.instantiateViewControllerWithIdentifier("UserInputViewController") as! UserInputViewController
            
            self.presentViewController(secondViewController, animated: true, completion: nil)
        }
    }

}

// Helper extension to display alerts easily.
extension UIViewController {
    func showAlert(withTitle title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}