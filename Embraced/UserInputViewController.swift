//
//  UserInputViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/8/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import Alamofire

class UserInputViewController: UIViewController {

    @IBOutlet weak var participantID: UILabel!
    @IBOutlet weak var dayOfTheWeekTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var countyTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var participantLabel: UILabel!
    
    
    let userDefaults = UserDefaults.standard
    let downloadManager = DownloadManager()
    let APIUrl = "http://www.embracedapi.ugr.es/"
    
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
        
//        let index = uuid.characters.index(uuid.endIndex, offsetBy: -15)
//        participantID.text = uuid.substring(to: index)
//        participant.setValue(uuid.substring(to: index), forKey: "pid")
        
        DataManager.sharedInstance.fetchStimuli()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitBtn.backgroundColor = UIColor(red: 23.0/225.0, green: 145.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
        participantLabel.text = "Participant_ID".localized(lang: userDefaults.string(forKey: "TesterLanguage")!)
        dayOfTheWeekTextField.placeholder = "Day_of_the_week".localized(lang: userDefaults.string(forKey: "TesterLanguage")!)
        countryTextField.placeholder = "Country".localized(lang: userDefaults.string(forKey: "TesterLanguage")!)
        countyTextField.placeholder = "County".localized(lang: userDefaults.string(forKey: "TesterLanguage")!)
        cityTextField.placeholder = "City".localized(lang: userDefaults.string(forKey: "TesterLanguage")!)
        locationTextField.placeholder = "Location".localized(lang: userDefaults.string(forKey: "TesterLanguage")!)
        floorTextField.placeholder = "Floor".localized(lang: userDefaults.string(forKey: "TesterLanguage")!)
        submitBtn.setTitle("Submit".localized(lang: userDefaults.string(forKey: "TesterLanguage")!), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        var jsonObject = [String: AnyObject]()
        let vc = StartViewController()
        let navController = UINavigationController(rootViewController: vc)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss a"
        let dateString = dateFormatter.string(from:date)
        
        // Gather data for post
        jsonObject = [
            "pid": userDefaults.string(forKey: "pid")! as AnyObject,
            "time": dateString as AnyObject,
            "dayOfWeek": dayOfTheWeekTextField.text as AnyObject,
            "country": countryTextField.text as AnyObject,
            "county": countyTextField.text as AnyObject,
            "city": cityTextField.text as AnyObject,
            "location": locationTextField.text as AnyObject,
            "floor": floorTextField.text as AnyObject
        ]

        
        let token = userDefaults.string(forKey: "token")!
        let pid = userDefaults.string(forKey: "pid")!
        let headers: HTTPHeaders = [
            "x-access-token": token
        ]
        
        Alamofire.request(APIUrl + "api/moca/new/" + pid, method: .post, parameters: jsonObject, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response)
            
            let statusCode = response.response?.statusCode
            
            if statusCode == 200 {
                self.present(navController, animated: true, completion: nil)
            }
        }
        
        
    }
}
