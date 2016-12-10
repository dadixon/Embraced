//
//  CPTViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import WebKit

class CPTViewController: WebViewController {
    
    override func viewDidLoad() {
        step = 11
        orientation = "landscape"
        url = URL(string: "http://girlscouts.harryatwal.com/cpt.php?id=" + participant.string(forKey: "pid")! + "&lang=" + participant.string(forKey: "language")!)
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    func next() {
        let vc:MatricesViewController = MatricesViewController()
        nextViewController(viewController: vc)
    }
    
    // MARK: - Delegate
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "callbackHandler") {
            next()
        }
        
    }
}
