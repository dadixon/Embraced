//
//  ReyComplexFigure2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import WebKit

class ReyComplexFigure2ViewController: WebViewController {
    
    override func viewDidLoad() {
        step = 5
        orientation = "portrait"
        url = URL (string: "http://girlscouts.harryatwal.com/reyComplexFigure2.php?id=" + participant.string(forKey: "pid")! + "&lang=" + participant.string(forKey: "language")!)
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next".localized(lang: participant.string(forKey: "language")!), style: .plain, target: self, action: #selector(ReyComplexFigure2ViewController.next(_:)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation
    
    func next(_ sender:Any) {
        let trailMakingTestViewController:TrailMakingTestViewController = TrailMakingTestViewController()
        nextViewController(viewController: trailMakingTestViewController)
    }
    
    // MARK: - Delegate
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "callbackHandler") {
            next(self)
        }
        
    }
}
