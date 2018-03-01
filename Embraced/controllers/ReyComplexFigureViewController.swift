//
//  ReyComplexFigureViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class ReyComplexFigureViewController: WebViewController {
    
    override func viewDidLoad() {
        step = AppDelegate.position
//        showOrientationAlert(orientation: "portrait")
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        url = URL(string: "http://www.embraced.ugr.es/reyComplexFigure.php?id=" + participant.string(forKey: "pid")! + "&lang=" + participant.string(forKey: "language")! + "&token=" + participant.string(forKey: "token")!)
        
        super.viewDidLoad()
        
        contentController.add(self, name: "addRCFHandler")
        contentController.add(self, name: "uploadData")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(.all)
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
        
        if message.name == "addRCFHandler" {
            Alamofire.request(APIUrl + "api/rcf/new/" + id, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            }
        } else if message.name == "uploadData" {
            let dict = message.body as! [String:AnyObject]
            
            Alamofire.request(APIUrl + "api/rcf/uploadfile/" + id, method: .post, parameters: dict, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                let statusCode = response.response?.statusCode
                
                if statusCode == 200 {
                    self.hideOverlayView()
                    self.next(self)
                }
            }
        }
    }
}
