//
//  Questionnaire2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/27/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class Questionnaire2ViewController: FrontViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    @IBAction func back(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func next(sender: AnyObject) {
        let VC1 = self.storyboard!.instantiateViewControllerWithIdentifier("Questionnaire3ViewController") as! Questionnaire3ViewController
        self.navigationController!.pushViewController(VC1, animated: true)
    }
 

}
