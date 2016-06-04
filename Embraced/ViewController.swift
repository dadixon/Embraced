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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    
    let nodeUrl = "http://54.201.210.104"
    let prefs = NSUserDefaults.standardUserDefaults()

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        Stormpath.sharedSession.me { (account, error) -> Void in
            if let account = account {
                self.nameLabel.text = "Hello \(account.fullName)!"
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInBtn.backgroundColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func login(sender: AnyObject) {
        Stormpath.sharedSession.login(usernameTextfield.text!, password: passwordTextfield.text!, completionHandler: logResponse)
    }
    
    func logResponse(success: Bool, error: NSError?) {
        if let error = error {
            showAlert(withTitle: "Error", message: error.localizedDescription)
        }
        else {
            showAlert(withTitle: "Success", message: "You logged in successfully")
            
            Stormpath.sharedSession.me { (account, error) -> Void in
                if let account = account {
                    self.nameLabel.text = "Hello \(account.fullName)!"
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