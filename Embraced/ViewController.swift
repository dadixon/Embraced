//
//  ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 5/28/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var nodeResponseView: UIWebView!
    
    let url = "http://girlscouts.harryatwal.com"
    let nodeUrl = "http://54.201.210.104/test"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestURL = NSURL(string:url)
        let request = NSURLRequest(URL: requestURL!)
        let requestNodeURL = NSURL(string:nodeUrl)
        let requestNode = NSURLRequest(URL: requestNodeURL!)
        
        webView.loadRequest(request)
        nodeResponseView.loadRequest(requestNode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}