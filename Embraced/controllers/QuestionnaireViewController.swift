//
//  QuestionnaireViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/6/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import WebKit

class QuestionnaireViewController: WebViewController {
    
    override func viewDidLoad() {
        step = AppDelegate.position
        orientation = "portrait"
        url = URL(string: "http://girlscouts.harryatwal.com/initial.php?id=" + participant.string(forKey: "pid")! + "&lang=" + participant.string(forKey: "language")!)
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next".localized(lang: participant.string(forKey: "language")!), style: .plain, target: self, action: #selector(QuestionnaireViewController.next(_:)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    func next(_ sender:Any) {
//        let vc:MOCAMMSETestViewController = MOCAMMSETestViewController()
//        nextViewController(viewController: vc)
//        let test = participant.array(forKey: "Tests")!
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
