//
//  ComprehensionViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class ComprehensionViewController: FrontViewController {

    @IBOutlet weak var myWebView: UIWebView!
    
    override func viewDidLoad() {
        step = 17
        
        super.viewDidLoad()
        
        orientation = "portrait"
        rotated()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(CancellationTestViewController.next(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(CancellationTestViewController.back(_:)))
        
        let url = URL (string: "http://girlscouts.harryatwal.com/comprehension.php");
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
        
        let eyeTestViewController:FinishedViewController = FinishedViewController()
        //        navigationArray?.append(eyeTestViewController)
        //
        //        self.navigationController?.setViewControllers(navigationArray!, animated: true)
        self.navigationController?.pushViewController(eyeTestViewController, animated: true)
    }
    
    @IBAction func back(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
