//
//  ReyFigureComplex4ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class ReyFigureComplex4ViewController: FrontViewController {

    @IBOutlet weak var myWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(getter: next))
        
        let url = URL (string: "http://girlscouts.harryatwal.com/reyComplexFigure.php");
        let requestObj = URLRequest(url: url!);
        myWebView.loadRequest(requestObj);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        //        var jsonObject = [String: AnyObject]()
        //
        //        // Gather data for post
        //        if let id = prefs.stringForKey("pid") {
        //            print("PID: " + id)
        //
        //            jsonObject = [
        //                "id": id,
        //                "hand": postValues
        //            ]
        //        }
        //
        //        print(jsonObject)
        
        
        // Push to API
        //            let notesEndpoint = NSURL(string: Stormpath.sharedSession.configuration.APIURL.absoluteString + "/insert_hand_dominate")!
        //            let request = NSMutableURLRequest(URL: notesEndpoint)
        //            request.HTTPMethod = "POST"
        //            request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(jsonObject, options: [])
        //            request.setValue("application/json" ?? "", forHTTPHeaderField: "Content-Type")
        //
        //            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        //            task.resume()
        
        var navigationArray = self.navigationController?.viewControllers
        
        navigationArray?.remove(at: 0)
        
        let cPTViewController:CPTViewController = CPTViewController()
        navigationArray?.append(cPTViewController)
        
        self.navigationController?.setViewControllers(navigationArray!, animated: true)
    }

}
