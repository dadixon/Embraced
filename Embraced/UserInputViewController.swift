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
        
        Stormpath.sharedSession.me { (account, error) -> Void in
            if let account = account {
                print("Hello \(account.fullName)!")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitBtn.backgroundColor = UIColor(red: 23.0/225.0, green: 145.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
        let uuid = UUID().uuidString
        let index = uuid.characters.index(uuid.endIndex, offsetBy: -28)
        participantID.text = uuid.substring(to: index)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func submit(_ sender: AnyObject) {
//        self.saveUserInputs()
        participant.setValue(participantID.text, forKey: "pid")
        participant.setValue(dayOfTheWeekTextField.text, forKey: "dayOfTheWeek")
        participant.setValue(countryTextField.text, forKey: "country")
        participant.setValue(countyTextField.text, forKey: "county")
        participant.setValue(cityTextField.text, forKey: "city")
        participant.setValue(locationTextField.text, forKey: "location")
        participant.setValue(floorTextField.text, forKey: "floor")

        
        
        let questionnaireViewController:WordListViewController = WordListViewController()
        let navController = UINavigationController(rootViewController: questionnaireViewController)
        self.present(navController, animated: true, completion: nil)
        
        
    }
}
