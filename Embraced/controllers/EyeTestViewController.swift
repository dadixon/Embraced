//
//  EyeTestViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class EyeTestViewController: FrontViewController, UIWebViewDelegate {

    @IBOutlet weak var myWebView: UIWebView!
    
    override func viewDidLoad() {
        step = 20
        
        super.viewDidLoad()
        
        orientation = "portrait"
        rotated()
        myWebView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(EyeTestViewController.next(_:)))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(EyeTestViewController.back(_:)))
        
        let url = URL (string: "http://girlscouts.harryatwal.com/eyeTest.php?id=" + participant.string(forKey: "pid")! + "&lang=" + participant.string(forKey: "language")!);
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
        
        let matricesViewController:FinishedViewController = FinishedViewController()
//        navigationArray?.append(matricesViewController)
//        
//        self.navigationController?.setViewControllers(navigationArray!, animated: true)
        self.navigationController?.pushViewController(matricesViewController, animated: true)
    }

//    @IBAction func back(_ sender: AnyObject) {
//        _ = self.navigationController?.popViewController(animated: true)
//    }
    
    // MARK: - Delegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingView.stopAnimating()
    }
}
