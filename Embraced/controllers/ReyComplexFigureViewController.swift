//
//  ReyComplexFigureViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import WebKit

class ReyComplexFigureViewController: WebViewController {
    
    override func viewDidLoad() {
        step = 3
        orientation = "portrait"
        url = URL(string: "http://girlscouts.harryatwal.com/reyComplexFigure.php?id=" + participant.string(forKey: "pid")! + "&lang=" + participant.string(forKey: "language")!)
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next".localized(lang: participant.string(forKey: "language")!), style: .plain, target: self, action: #selector(ReyComplexFigureViewController.next(_:)))
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    func next(_ sender:Any) {
        let vc:ClockDrawingTestViewController = ClockDrawingTestViewController()
        nextViewController(viewController: vc)
    }

    // MARK: - Delegate
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "callbackHandler") {
            next(self)
        }
        
    }
}
