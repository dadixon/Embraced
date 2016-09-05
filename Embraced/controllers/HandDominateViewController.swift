//
//  HandDominateViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class HandDominateViewController: FrontViewController {

    var step = 2
    var progress : Float {
        get {
            return Float(step) / 17.0
        }
    }

    var postValues = [String](count: 10, repeatedValue: "")
    var strongHand = String()
    let prefs = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var writingSegment: UISegmentedControl!
    @IBOutlet weak var drawingSegment: UISegmentedControl!
    @IBOutlet weak var throwing: UISegmentedControl!
    @IBOutlet weak var scissorsSegment: UISegmentedControl!
    @IBOutlet weak var toothbrushSegment: UISegmentedControl!
    @IBOutlet weak var knifeSegment: UISegmentedControl!
    @IBOutlet weak var spoonSegment: UISegmentedControl!
    @IBOutlet weak var broomSegment: UISegmentedControl!
    @IBOutlet weak var matchSegment: UISegmentedControl!
    @IBOutlet weak var lidSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = progress
        progressLabel.text = "Progress (\(step)/17)"

        writingSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        drawingSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        throwing.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        scissorsSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        toothbrushSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        knifeSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        spoonSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        broomSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        matchSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        lidSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    func segmentChanged(sender: UISegmentedControl) {
        var hand = String()
        
        if(sender.selectedSegmentIndex == 0) {
            hand = "L"
        } else if(sender.selectedSegmentIndex == 1) {
            hand = "R"
        }
        postValues.removeAtIndex(sender.tag)
        postValues.insert(hand, atIndex: sender.tag)
        
        print(postValues)
        
        var lefty = 0
        var righty = 0
        
        for hand in postValues {
            if (hand == "L") {
                lefty += 1
            } else if (hand == "R") {
                righty += 1
            }
        }
        
        if (lefty > righty) {
            strongHand = "L"
        } else {
            strongHand = "R"
        }
        
        print(strongHand)
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func next(sender: AnyObject) {
        var jsonObject = [String: AnyObject]()
            
        // Gather data for post
        if let id = prefs.stringForKey("pid") {
            print("PID: " + id)
                
            jsonObject = [
                "id": id,
                "hand": postValues
            ]
        }
            
        print(jsonObject)
        
        prefs.setValue(strongHand, forKey: "strongHand")
            
            // Push to API
            //            let notesEndpoint = NSURL(string: Stormpath.sharedSession.configuration.APIURL.absoluteString + "/insert_hand_dominate")!
            //            let request = NSMutableURLRequest(URL: notesEndpoint)
            //            request.HTTPMethod = "POST"
            //            request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(jsonObject, options: [])
            //            request.setValue("application/json" ?? "", forHTTPHeaderField: "Content-Type")
            //
            //            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            //            task.resume()
            

        
    }
}
