//
//  ComprehensionViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import WebKit

class ComprehensionViewController: WebViewController {
    
    override func viewDidLoad() {
        step = AppDelegate.position
        showOrientationAlert(orientation: "landscape")
        url = URL(string: "http://www.embraced.ugr.es/comprehension.php?id=" + participant.string(forKey: "pid")! + "&lang=" + participant.string(forKey: "language")! + "&token=" + participant.string(forKey: "token")!)
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    func next(_ sender:Any) {
//        let vc:EyeTestViewController = EyeTestViewController()
//        nextViewController(viewController: vc)
        AppDelegate.position += 1
        nextViewController2(position: AppDelegate.position)
    }
    
    // MARK: - Delegate
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "callbackHandler") {
            next(self)
        }
        
    }
}
