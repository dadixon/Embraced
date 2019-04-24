//
//  PegboardViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class PegboardViewController: WebViewController {
    
    override func viewDidLoad() {
        step = AppDelegate.position
//        showOrientationAlert(orientation: "landscape")
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        url = URL(string: "http://www.embraced.ugr.es/motorTask.php?id=" + participant.string(forKey: "pid")! + "&lang=" + participant.string(forKey: "language")! + "&token=" + participant.string(forKey: "token")!)
        
        super.viewDidLoad()
        
        contentController.add(self, name: "uploadData")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.landscape)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    // MARK: - Navigation
    
    func next(_ sender:Any) {
        AppDelegate.position += 1
        AppDelegate.testPosition += 1
        self.navigationController?.pushViewController(TestOrder.sharedInstance.getTest(AppDelegate.testPosition), animated: true)
    }
    
    // MARK: - Delegate
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let id = participant.string(forKey: "pid")!
        let token = participant.string(forKey: "token")!
        let headers: HTTPHeaders = [
            "x-access-token": token
        ]
        let APIUrl = "http://www.embracedapi.ugr.es/"
        
        if message.name == "uploadData" {
            let data = message.body as! [String:Any]
            
            Alamofire.request(APIUrl + "api/pegboard/new/" + id, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                let statusCode = response.response?.statusCode
                
                if statusCode == 200 {
                    self.hideOverlayView()
                    self.next(self)
                }
            }
        }
    }
}
