//
//  Question3ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/20/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class Question3ViewController: FrontViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(Question3ViewController.next(_:)))
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
