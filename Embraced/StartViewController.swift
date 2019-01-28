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

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.navigationController?.isNavigationBarHidden = true
        
        welcomeLabel.text = "WELCOME_TO_EMBRACED_PROJECT".localized(lang: participant.string(forKey: "TesterLanguage")!)
        welcomeText.text = "WELCOME_TEXT".localized(lang: participant.string(forKey: "TesterLanguage")!)
        nextBtn.setTitle("Start".localized(lang: participant.string(forKey: "TesterLanguage")!), for: .normal)
        
        participant.setValue("en", forKey: "language")
        DataManager.sharedInstance.language = "en"
        DataManager.sharedInstance.updateData()
        
        languagePicker.delegate = self
        languagePicker.dataSource = self
        
        pickerData = ["English": "en", "Spanish": "es"]
        
        let token = participant.string(forKey: "token")!
        StorageManager.sharedInstance.token = token
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    // MARK: - Navigation
    
    @IBAction func startTest(_ sender: Any) {
        // Save participant language
        do {
            let id = participant.string(forKey: "pid")!
            
            try StorageManager.sharedInstance.putToAPI(endpoint: "participant/update/", id: id, data: createPostObject())
            
            // Save test timer
//            let date = Date()
            let date = Date().millisecondsSince1970
            participant.setValue(date, forKey: "StartDate")
            
            AppDelegate.testPosition += 1
            self.navigationController?.pushViewController(
                TestOrder.sharedInstance.getTest(AppDelegate.testPosition), animated: true)
        } catch let error {
            print(error)
        }
    }
 
    private func createPostObject() -> [String: Any] {
        var jsonObject = [String: Any]()
        
        // Gather data for post
        jsonObject = [
            "language": participant.string(forKey: "language")!
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
        DataManager.sharedInstance.language = pickerData[componentArray[row]]!
        DataManager.sharedInstance.updateData()
        
        welcomeLabel.text = "WELCOME_TO_EMBRACED_PROJECT".localized(lang: participant.string(forKey: "language")!)
        welcomeText.text = "WELCOME_TEXT".localized(lang: participant.string(forKey: "language")!)
        nextBtn.setTitle("Start".localized(lang: participant.string(forKey: "language")!), for: .normal)
    }
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
