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
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    @IBAction func startOver(_ sender: AnyObject) {
        let reyComplexFigureViewController:UserInputViewController = UserInputViewController()
        
        self.navigationController?.pushViewController(reyComplexFigureViewController, animated: true)
    }
    

}
