//
//  UserInputViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/8/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import Stormpath
import CoreData

class UserInputViewController: UIViewController {

    @IBOutlet weak var participantID: UILabel!
    @IBOutlet weak var dayOfTheWeekTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var countyTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    let participant = UserDefaults.standard
    let downloadManager = DownloadManager()
    let uuid = UUID().uuidString
    
    fileprivate func setBottomBorder(_ textfield: UITextField) {
        let border = CALayer()
        let width = CGFloat(2.0)
        let borderColor = UIColor.darkGray.cgColor
        
        border.borderColor = borderColor
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: textfield.frame.size.height, width:  textfield.frame.size.width, height: 1)
        
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        let index = uuid.characters.index(uuid.endIndex, offsetBy: -15)
        participantID.text = uuid.substring(to: index)
        participant.setValue(uuid.substring(to: index), forKey: "pid")
        
        DataManager.sharedInstance.fetchStimuli()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitBtn.backgroundColor = UIColor(red: 23.0/225.0, green: 145.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        print(participant.string(forKey: "pid")!)
        
        var jsonObject = [String: AnyObject]()
        
        // Gather data for post
        jsonObject = [
            "id": participant.string(forKey: "pid")! as AnyObject,
            "dayOfWeek": dayOfTheWeekTextField.text as AnyObject,
            "country": countryTextField.text as AnyObject,
            "county": countyTextField.text as AnyObject,
            "city": cityTextField.text as AnyObject,
            "location": locationTextField.text as AnyObject,
            "floor": floorTextField.text as AnyObject
        ]

        
        // Push to API
//        APIWrapper.post(id: "", test: "", data: jsonObject)      
        
        let vc = StartViewController()
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
    
//    func downloadFileFromURL(url:NSURL, x: Int, y: Int){
//        var downloadTask:URLSessionDownloadTask
//        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { (URL, response, error) -> Void in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//            print(URL! as NSURL)
//            print(x)
//            self.examples2[x][y] = URL! as URL
//        })
//        
//        downloadTask.resume()
//    }
}
