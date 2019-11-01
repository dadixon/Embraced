//
//  UserInputViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/8/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class UserInputViewController: UIViewController {

    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var countyTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    let userDefaults = UserDefaults.standard
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitBtn.backgroundColor = UIColor(red: 23.0/225.0, green: 145.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
        countryTextField.placeholder = "Country".localized(lang: userDefaults.string(forKey: "TesterLanguage")!)
        countyTextField.placeholder = "County".localized(lang: userDefaults.string(forKey: "TesterLanguage")!)
        cityTextField.placeholder = "City".localized(lang: userDefaults.string(forKey: "TesterLanguage")!)
        locationTextField.placeholder = "Location".localized(lang: userDefaults.string(forKey: "TesterLanguage")!)
        floorTextField.placeholder = "Floor".localized(lang: userDefaults.string(forKey: "TesterLanguage")!)
        submitBtn.setTitle("Submit".localized(lang: userDefaults.string(forKey: "TesterLanguage")!), for: .normal)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        var jsonObject = [String: Any]()
        
        let date = Date()
        var calendar = Calendar.current
        calendar.locale = Locale.autoupdatingCurrent

        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let weekday = calendar.component(.weekdayOrdinal, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        
        // Gather data for post
        jsonObject = [
            "pid": userDefaults.string(forKey: "pid")!,
            "year": year,
            "month": month,
            "dayOfWeek": formatWeekday(weekday),
            "date": day,
            "hour": hour,
            "minute": minute,
            "ampm": hour > 11 ? calendar.pmSymbol : calendar.amSymbol,
            "country": countryTextField.text!,
            "county": countyTextField.text!,
            "city": cityTextField.text!,
            "location": locationTextField.text!,
            "floor": floorTextField.text!
        ]

    }
    
    private func formatWeekday(_ day: Int) -> String {
        switch day {
        case 0:
            return "Monday"
        case 1:
            return "Tuesday"
        case 2:
            return "Wednesday"
        case 3:
            return "Thursday"
        case 4:
            return "Friday"
        case 5:
            return "Saturday"
        case 6:
            return "Sunday"
        default:
            return ""
        }
    }
}
