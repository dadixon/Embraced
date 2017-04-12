//
//  AdminViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/22/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class AdminViewController: UITabBarController, UITabBarControllerDelegate {
    
    let participant = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set Tester language: Default is en - English
        var testerLanguage = "en"
        
        if let language = participant.string(forKey: "TesterLanguage") {
            testerLanguage = language
        }
        
        participant.setValue(testerLanguage, forKey: "TesterLanguage")
        
        let item1 = UserViewController()
        let item2 = SettingsViewController()
        let icon1 = UITabBarItem(title: "Test".localized(lang: testerLanguage), image: UIImage(named: "iconTab0.png"), selectedImage: UIImage(named: "iconTab0.png"))
        let icon2 = UITabBarItem(title: "Settings".localized(lang: testerLanguage), image: UIImage(named: "iconTab1.png"), selectedImage: UIImage(named: "iconTab1.png"))
        item1.tabBarItem = icon1
        item2.tabBarItem = icon2
        let controllers = [item1, item2]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(String(describing: viewController.title)) ?")
        return true;
    }
}
