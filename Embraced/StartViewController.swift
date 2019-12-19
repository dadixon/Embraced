//
//  StartViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/30/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var nextBtn: NavigationButton!
    @IBOutlet weak var languagePicker: UIPickerView!
    
    let participant = UserDefaults.standard
    var pickerData: [String:String] = [String:String]()
    var componentArray = [String]()
    var startBtnWidth: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.navigationController?.isNavigationBarHidden = true
        
        languagePicker.delegate = self
        languagePicker.dataSource = self
        
        pickerData = ["English": "en", "Spanish": "es"]
        componentArray = Array(pickerData.keys)
        
        DataManager.sharedInstance.language = pickerData[componentArray[0]]!
        DataManager.sharedInstance.updateData()
        participant.setValue(pickerData[componentArray[0]]!, forKey: "language")
        
        welcomeLabel.text = "WELCOME_TO_EMBRACED_PROJECT".localized(lang: DataManager.sharedInstance.language)
        welcomeText.text = "WELCOME_TEXT".localized(lang: DataManager.sharedInstance.language)
        nextBtn.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        nextBtn.setTitle("Start".localized(lang: DataManager.sharedInstance.language), for: .normal)
        startBtnWidth = nextBtn.widthAnchor.constraint(equalToConstant: nextBtn.intrinsicContentSize.width + 100.0)
        startBtnWidth?.isActive = true
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    // MARK: - Navigation
    
    @IBAction func startTest(_ sender: Any) {
        FirebaseStorageManager.shared.addDataToDocument(payload: [
            "language": DataManager.sharedInstance.language
        ])
        
        AppDelegate.testPosition += 1
        
        TestConfig.shared.testStartTime = CFAbsoluteTimeGetCurrent()
        
        // Load media here before test if needed
        
        if TestConfig.shared.testListName.contains("Eyes Test") {
            for name in DataManager.sharedInstance.eyesTestImages {
                FirebaseStorageManager.shared.getFile(fileName: name, test: "eyesTest", lang: "")
            }
        }
        
        if TestConfig.shared.testListName.contains("Matrices") {
            for task in DataManager.sharedInstance.matricesStimuli {
                FirebaseStorageManager.shared.getFile(fileName: task.displayImageName, test: "matrices", lang: "")
                
                for choice in task.choices {
                    FirebaseStorageManager.shared.getFile(fileName: choice, test: "matrices", lang: "")
                }
            }
        }
        
        // Reset all test models
        MelodyRecognitionModel.shared.reset()
        CancellationModel.shared.reset()
        WordListModel.shared.reset()
        DigitSpanModel.shared.reset()
        StroopModel.shared.reset()
        NamingTaskModel.shared.reset()
        ClockDrawingModel.shared.reset()
        RCFTModel.shared.reset()
        TrailMakingModel.shared.reset()
        ComprehensionModel.shared.reset()
        EyeTestModel.shared.reset()
        MatricesModel.shared.reset()
        
        self.navigationController?.pushViewController(TestConfig.shared.testList[0], animated: true)
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
        return componentArray[row].localized(lang: participant.string(forKey: "language")!)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        participant.setValue(pickerData[componentArray[row]]!, forKey: "language")
        DataManager.sharedInstance.language = pickerData[componentArray[row]]!
        DataManager.sharedInstance.updateData()
        
        welcomeLabel.text = "WELCOME_TO_EMBRACED_PROJECT".localized(lang: participant.string(forKey: "language")!)
        welcomeText.text = "WELCOME_TEXT".localized(lang: participant.string(forKey: "language")!)
        nextBtn.setTitle("Start".localized(lang: participant.string(forKey: "language")!), for: .normal)
        startBtnWidth?.constant = nextBtn.intrinsicContentSize.width + 100.0
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
