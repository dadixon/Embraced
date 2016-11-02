//
//  QuestionnaireViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/6/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class QuestionnaireViewController: FrontViewController, UIWebViewDelegate {

    @IBOutlet weak var myWebView: UIWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController?.addAction(defaultAction)
        self.present(alertController!, animated: true, completion: nil)
        
        let url = URL (string: "http://girlscouts.harryatwal.com/initial.php?id=" + participant.string(forKey: "pid")!);
        let requestObj = URLRequest(url: url!);
        myWebView.loadRequest(requestObj);
    }
    
    override func viewDidLoad() {
        step = 1
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        myWebView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(QuestionnaireViewController.next(_:)))
        
        alertController = UIAlertController(title: "Orientation", message: "Please turn the device to portrait orientation and do not turn until stated.", preferredStyle: .alert)
        
        
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
    
    
    // MARK: - Delegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingView.stopAnimating()
    }
}
