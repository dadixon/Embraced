//
//  ResidenceViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/7/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class ResidenceViewController: FrontViewController {

    var step = 5
    var progress : Float {
        get {
            return Float(step) / 17.0
        }
    }
    
    var postValues = [String](count: 10, repeatedValue: "")
    let prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    @IBAction func back(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func next(sender: AnyObject) {
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
        
        let VC1 = self.storyboard!.instantiateViewControllerWithIdentifier("CPTViewController") as! CPTViewController
        self.navigationController!.pushViewController(VC1, animated: true)
        
    }

}