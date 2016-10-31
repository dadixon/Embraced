//
//  QuestionnaireViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/6/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class QuestionnaireViewController: FrontViewController {

    @IBOutlet weak var myWebView: UIWebView!
    
    override func viewDidLoad() {
        step = 1
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(QuestionnaireViewController.next(_:)))
        
        print("some url \(participant.string(forKey: "pid")!)")
        
        let url = URL (string: "http://girlscouts.harryatwal.com/initial.php?id=" + participant.string(forKey: "pid")!);
        let requestObj = URLRequest(url: url!);
        myWebView.loadRequest(requestObj);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        
        var navigationArray = self.navigationController?.viewControllers
        
        navigationArray?.remove(at: 0)
        
        let mOCAMMSETestViewController:MOCAMMSETestViewController = MOCAMMSETestViewController()
        navigationArray?.append(mOCAMMSETestViewController)
        
        self.navigationController?.setViewControllers(navigationArray!, animated: true)
    }
}
