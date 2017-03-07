//
//  FinishedViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/6/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class FinishedViewController: FrontViewController {

    override func viewDidLoad() {
        step = AppDelegate.position
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    @IBAction func startOver(_ sender: AnyObject) {
        AppDelegate.position = 0
        
        let vc = AdminViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
