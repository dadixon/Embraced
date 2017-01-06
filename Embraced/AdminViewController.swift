//
//  AdminViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/22/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class AdminViewController: UITabBarController, UITabBarControllerDelegate {
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let item1 = UserViewController()
        let item2 = ChooseTestViewController()
        let icon1 = UITabBarItem(title: "Test", image: UIImage(named: "iconTab0.png"), selectedImage: UIImage(named: "iconTab0.png"))
        let icon2 = UITabBarItem(title: "Setting", image: UIImage(named: "iconTab1.png"), selectedImage: UIImage(named: "iconTab1.png"))
        item1.tabBarItem = icon1
        item2.tabBarItem = icon2
        let controllers = [item1, item2]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
}
