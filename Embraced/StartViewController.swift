//
//  StartViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/30/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    let participant = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Embraced_bg.png")!)
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    // MARK: - Navigation
    @IBAction func chooseLanguage(_ sender: AnyObject) {
        if sender.tag == 0 {
            participant.set("en-us", forKey: "language")
        } else if sender.tag == 1 {
            participant.set("sp", forKey: "langauge")
        }
        
        var navigationArray = self.navigationController?.viewControllers
        
        navigationArray?.remove(at: 0)
        
//        let questionnaireViewController:QuestionnaireViewController = QuestionnaireViewController()
        let questionnaireViewController:DigitalSpanViewController = DigitalSpanViewController()
        navigationArray?.append(questionnaireViewController)
        
        self.navigationController?.setViewControllers(navigationArray!, animated: true)
        
//        let questionnaireViewController:QuestionnaireViewController = QuestionnaireViewController()
//        self.navigationController?.pushViewController(questionnaireViewController, animated: true)
    }
    
 
    
    

}
