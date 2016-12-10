//
//  WebViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/10/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: FrontViewController, WKNavigationDelegate, WKScriptMessageHandler {

    var webView: WKWebView!
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        rotated()
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "callbackHandler")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: CGRect(x: 0, y: 48, width: 300, height: 300), configuration: config)
        view.addSubview(webView)
        
        webView.navigationDelegate = self
        
        let requestObj = URLRequest(url: url!)
        
        webView.load(requestObj)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let leftConstraint = webView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor)
        let topConstraint = webView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 48.0)
        let rightConstraint = webView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor)
        let bottomConstraint = webView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Stop Animation")
        loadingView.stopAnimating()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}
