//
//  Question3ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/20/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class Question3ViewController: FrontViewController {

    
    var step = 3
    var totalSteps = 3
    var progress : Float {
        get {
            return Float(step) / Float(totalSteps)
        }
    }
    
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
        
        let mOCAMMSETestViewController:MOCAMMSETestViewController = MOCAMMSETestViewController()
        navigationArray?.append(mOCAMMSETestViewController)
        
        self.navigationController?.setViewControllers(navigationArray!, animated: true)
    }

}
