//
//  TestViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/20/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class TestViewController: FrontViewController {
    
    var pickOption = ["Male", "Female", "Other"]
    var step = 1
    var totalSteps = 17
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func back(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: AnyObject) {
        let testViewController:TestViewController = TestViewController()
        self.navigationController!.pushViewController(testViewController, animated: true)
    }
}
