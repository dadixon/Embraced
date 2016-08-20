//
//  Question1ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/20/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class Question1ViewController: FrontViewController {

    var pickOption = ["Male", "Female", "Other"]
    var step = 1
    var totalSteps = 17
    var progress : Float {
        get {
            return Float(step) / Float(totalSteps)
        }
    }
    let prefs = NSUserDefaults.standardUserDefaults()
    
    var postValues = [String](count: 10, repeatedValue: "")
    var strongHand = String()
    var childPickOption = ["Male", "Female"]
    var ages = [String]()
    var sexes = [String]()
    
    let textCellIdentifier = "ChildTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(next))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func next(sender: AnyObject) {
        let question2ViewController:Question2ViewController = Question2ViewController()
        self.navigationController!.pushViewController(question2ViewController, animated: true)
    }

}
