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
    
    let prefs = UserDefaults.standard
    
    var postValues = [String](repeating: "", count: 10)
    var strongHand = String()
    var childPickOption = ["Male", "Female"]
    var ages = [String]()
    var sexes = [String]()
    
    let textCellIdentifier = "ChildTableViewCell"
    
    override func viewDidLoad() {
        step = 2
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(Question2ViewController.next(_:)))
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
