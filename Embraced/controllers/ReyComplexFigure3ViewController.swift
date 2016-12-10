//
//  ReyComplexFigure3ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import WebKit

class ReyComplexFigure3ViewController: WebViewController {
    
    override func viewDidLoad() {
        step = 9
        orientation = "portrait"
        url = URL(string: "http://girlscouts.harryatwal.com/reyComplexFigure3.php?id=" + participant.string(forKey: "pid")! + "&lang=" + participant.string(forKey: "language")!)
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    func next() {
        let vc:ReyFigureComplex4ViewController = ReyFigureComplex4ViewController()
        nextViewController(viewController: vc)
    }
    
    
    // MARK: - Delegate
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "callbackHandler") {
            next()
        }
        
    }
}
