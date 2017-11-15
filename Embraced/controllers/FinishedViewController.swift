//
//  FinishedViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/6/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class FinishedViewController: FrontViewController {

    @IBOutlet weak var finishedLabel: UILabel!
    @IBOutlet weak var startOverBtn: NavigationButton!
    
    override func viewDidLoad() {
        step = AppDelegate.position
        
        super.viewDidLoad()

        language = participant.string(forKey: "language")!
        
        finishedLabel.text = "Finished".localized(lang: language)
        startOverBtn.setTitle("Start_over".localized(lang: language), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    @IBAction func startOver(_ sender: AnyObject) {
        AppDelegate.position = 0
        AppDelegate.testPosition = 0
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
