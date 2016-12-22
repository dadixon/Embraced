//
//  MOCAMMSETestViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import WebKit

class MOCAMMSETestViewController: WebViewController {
    
    override func viewDidLoad() {
        step = AppDelegate.position
        orientation = "portrait"
        url = URL (string: "http://girlscouts.harryatwal.com/MoCA_MMSE.php?id=" + participant.string(forKey: "pid")! + "&lang=" + participant.string(forKey: "language")!)
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next".localized(lang: participant.string(forKey: "language")!), style: .plain, target: self, action: #selector(MOCAMMSETestViewController.next(_:)))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation
    
    func next(_ sender:Any) {
//        let vc = ReyComplexFigureViewController()
//        nextViewController(viewController: vc)
        
        AppDelegate.position += 1
        nextViewController2(position: AppDelegate.position)
    }
    
    // MARK: - Delegate
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("Testing")
        if (message.name == "callbackHandler") {
            next(self)
        }
        
    }
}
