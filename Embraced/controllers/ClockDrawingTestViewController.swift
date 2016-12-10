//
//  ClockDrawingTestViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import WebKit

class ClockDrawingTestViewController: WebViewController {
    
    override func viewDidLoad() {
        step = 4
        orientation = "portrait"
        url = URL(string: "http://girlscouts.harryatwal.com/clockDrawing.php?id=" + participant.string(forKey: "pid")! + "&lang=" + participant.string(forKey: "language")!)
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    func next() {
        let vc:ReyComplexFigure2ViewController = ReyComplexFigure2ViewController()
        nextViewController(viewController: vc)
    }
    
    // MARK: - Delegate
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "callbackHandler") {
            next()
        }
        
    }
}
