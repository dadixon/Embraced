//
//  ClockDrawingTestViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class ClockDrawingTestViewController: FrontViewController {

    @IBOutlet weak var myWebView: UIWebView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = "portrait"
        rotated()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(ClockDrawingTestViewController.next(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(ClockDrawingTestViewController.back(_:)))
        
        let url = URL (string: "http://girlscouts.harryatwal.com/clockDrawing.php");
        let requestObj = URLRequest(url: url!);
        myWebView.loadRequest(requestObj);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    @IBAction func next(_ sender: AnyObject) {       
//        var navigationArray = self.navigationController?.viewControllers
//        
//        navigationArray?.remove(at: 0)
        
        let reyComplexFigure2ViewController:ReyComplexFigure2ViewController = ReyComplexFigure2ViewController()
//        navigationArray?.append(reyComplexFigure2ViewController)
//        
//        self.navigationController?.setViewControllers(navigationArray!, animated: true)
        self.navigationController?.pushViewController(reyComplexFigure2ViewController, animated: true)
    }
    
    @IBAction func back(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
