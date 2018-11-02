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
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        step = AppDelegate.position
        
        super.viewDidLoad()

        // Store time for the test
        let nowDate = Date().millisecondsSince1970
        let startDate = userDefaults.object(forKey: "StartDate") as! Int
        let participantDuration = ["duration": nowDate - startDate]
        
        let token = participant.string(forKey: "token")!
        StorageManager.sharedInstance.token = token
        
        // Save participant duration time
        do {
            let id = participant.string(forKey: "pid")!
            
            try StorageManager.sharedInstance.putToAPI(endpoint: "participant/update/", id: id, data: participantDuration)
        } catch let error {
            print(error)
        }
        
        language = participant.string(forKey: "language")!
        
        finishedLabel.text = "Finished".localized(lang: language)
        startOverBtn.setTitle("Start_over".localized(lang: language), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation

    @IBAction func startOver(_ sender: AnyObject) {
        AppDelegate.position = 0
        AppDelegate.testPosition = 0
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
