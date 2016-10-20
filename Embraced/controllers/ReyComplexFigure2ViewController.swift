//
//  ReyComplexFigure2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class ReyComplexFigure2ViewController: FrontViewController {

    @IBOutlet weak var myWebView: UIWebView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = "portrait"
        rotated()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(ReyComplexFigure2ViewController.next(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(ReyComplexFigure2ViewController.back(_:)))
        
        let url = URL (string: "http://girlscouts.harryatwal.com/reyComplexFigure2.php");
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
        
        let trailMakingTestViewController:TrailMakingTestViewController = TrailMakingTestViewController()
//        navigationArray?.append(trailMakingTestViewController)
//        
//        self.navigationController?.setViewControllers(navigationArray!, animated: true)
        self.navigationController?.pushViewController(trailMakingTestViewController, animated: true)
    }

    @IBAction func back(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
