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
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var nodeResponseView: UIWebView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let url = "http://girlscouts.harryatwal.com"
    var nodeUrl = "http://localhost:3000"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestURL = NSURL(string:url)
        let request = NSURLRequest(URL: requestURL!)
        let requestNodeURL = NSURL(string:nodeUrl)
        let requestNode = NSURLRequest(URL: requestNodeURL!)
        
        webView.loadRequest(request)
        nodeResponseView.loadRequest(requestNode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            let notesEndpoint = NSURL(string: "http://localhost:3000/secret")!
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
            
            nodeResponseView.loadRequest(request)
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