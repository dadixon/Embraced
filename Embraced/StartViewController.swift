//
//  StartViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/30/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import Alamofire

class StartViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var languagePicker: UIPickerView!
    
    let participant = UserDefaults.standard
    let APIUrl = "http://www.embracedapi.ugr.es/"
    var pickerData: [String:String] = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Embraced_bg.png")!)
        self.navigationController?.isNavigationBarHidden = true
        
        welcomeLabel.text = "WELCOME_TO_EMBRACED_PROJECT".localized(lang: participant.string(forKey: "TesterLanguage")!)
        welcomeText.text = "WELCOME_TEXT".localized(lang: participant.string(forKey: "TesterLanguage")!)
        nextBtn.setTitle("Start".localized(lang: participant.string(forKey: "TesterLanguage")!), for: .normal)
        
        participant.setValue("en", forKey: "language")
        
        languagePicker.delegate = self
        languagePicker.dataSource = self
        
        pickerData = ["English": "en", "Spanish": "es"]
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    // MARK: - Navigation
    
    @IBAction func startTest(_ sender: Any) {
        // TODO: Update participant language chosen in the db

        AppDelegate.testPosition += 1
        self.navigationController?.pushViewController(TestOrder.sharedInstance.getTest(AppDelegate.testPosition), animated: true)
        
    }
 
    private func createPostObject() -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        
        // Gather data for post
        jsonObject = [
            "language": participant.string(forKey: "language")! as AnyObject
        ]
        
        return jsonObject
    }
}

extension StartViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let componentArray = Array(pickerData.keys)
        return componentArray[row].localized(lang: participant.string(forKey: "language")!)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let componentArray = Array(pickerData.keys)
        
        participant.setValue(pickerData[componentArray[row]]!, forKey: "language")
        
        welcomeLabel.text = "WELCOME_TO_EMBRACED_PROJECT".localized(lang: participant.string(forKey: "language")!)
        welcomeText.text = "WELCOME_TEXT".localized(lang: participant.string(forKey: "language")!)
        nextBtn.setTitle("Start".localized(lang: participant.string(forKey: "language")!), for: .normal)
    }
}
