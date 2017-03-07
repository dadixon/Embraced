//
//  UserViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/27/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var startBtn: NavigationButton!
    
    let participant = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        if let language = participant.string(forKey: "TesterLanguage") {
            startBtn.setTitle("Start_Test".localized(lang: language), for: .normal)
        } else {
            startBtn.setTitle("Start Test", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startTest(_ sender: Any) {
        let vc = UserInputViewController()
        self.present(vc, animated: true, completion: nil)
    }
}
