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
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(QuestionnaireViewController.next(_:)))
        
        let url = URL (string: "http://girlscouts.harryatwal.com/initial.php");
        let requestObj = URLRequest(url: url!);
        myWebView.loadRequest(requestObj);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func rotated() {
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
            let alertController = UIAlertController(title: "Rotate", message: "Please rotate iPad to portrait orientation", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
//        var jsonObject = [String: AnyObject]()
//        
//        // Gather data for post
//        if let id = prefs.string(forKey: "pid") {
//            print("PID: " + id)
//            
//            jsonObject = [
//                "id": id as AnyObject,
//                "dob": dobTextField.text! as AnyObject,
//                "gender": genderTextField.text! as AnyObject,
//                "hand_dominate": postValues as AnyObject
//            ]
//        } else {
//            // Nothing stored in NSUserDefaults yet. Set a value.
//            prefs.setValue("pid", forKey: "pid")
//        }
//        
//        print(jsonObject)
//        
//        // Push to API
//        let notesEndpoint = NSURL(string: Stormpath.sharedSession.configuration.APIURL.absoluteString + "/insert_participant")!
//        let request = NSMutableURLRequest(url: notesEndpoint as URL)
//        
//        request.httpMethod = "POST"
//        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
//        request.setValue("application/json" , forHTTPHeaderField: "Content-Type")
//        
//        let task = URLSession.shared.dataTask(with: request as URLRequest)
//        
//        task.resume()
        
        var navigationArray = self.navigationController?.viewControllers
        
        navigationArray?.remove(at: 0)
        
        let mOCAMMSETestViewController:MOCAMMSETestViewController = MOCAMMSETestViewController()
        navigationArray?.append(mOCAMMSETestViewController)
        
        self.navigationController?.setViewControllers(navigationArray!, animated: true)
    }
}
