//
//  FinishedViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/6/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import Firebase

class FinishedViewController: FrontViewController {

    @IBOutlet weak var finishedLabel: UILabel!
    @IBOutlet weak var startOverBtn: NavigationButton!
    
    let userDefaults = UserDefaults.standard
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        step = AppDelegate.position
        
        super.viewDidLoad()

        let date = Date()
        let calendar = Calendar.current
        let startDate = userDefaults.object(forKey: "StartDate") as! Date
        let time = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: date)
        let pid = userDefaults.string(forKey: "FBPID")!
        ref = Database.database().reference()
        let childUpdates = ["/participants/\(pid)/time": time.hour! * 3600000 + time.minute! * 60000 + time.second! * 1000]
        ref.updateChildValues(childUpdates)
        
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
