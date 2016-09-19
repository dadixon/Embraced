//
//  Question2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/20/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class Question2ViewController: FrontViewController {

    var pickOption = ["Male", "Female", "Other"]
    var step = 2
    var totalSteps = 3
    var progress : Float {
        get {
            return Float(step) / Float(totalSteps)
        }
    }
    
    let prefs = UserDefaults.standard
    
    var postValues = [String](repeating: "", count: 10)
    var strongHand = String()
    var childPickOption = ["Male", "Female"]
    var ages = [String]()
    var sexes = [String]()
    
    let textCellIdentifier = "ChildTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = progress
        progressLabel.text = "Progress (\(step)/\(totalSteps))"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(getter: next))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func next(_ sender: AnyObject) {
        var navigationArray = self.navigationController?.viewControllers
        
        navigationArray?.remove(at: 0)
        
        let question3ViewController:Question3ViewController = Question3ViewController()
        navigationArray?.append(question3ViewController)
        
        self.navigationController?.setViewControllers(navigationArray!, animated: true)
    }

}
