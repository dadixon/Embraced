//
//  MonthViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 2/25/20.
//  Copyright © 2020 Domonique Dixon. All rights reserved.
//

import UIKit
import Eureka

class MonthViewController: FormViewController {

    let userDefaults = UserDefaults.standard
    var language = String()
    var months: [String] = []
    var dataModel = QuestionnaireModel.shared
//
//    Assessment date and time (automatic)
//    Date of birth: Year, Month, day
//    Age (automatic when DOB entered)
//    Gender: Male (1)/Female (2)/ Other (3)

    
    struct FormItems {
        static let birthDate = "birthDate"
        static let gender = "gender"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Step \(TestConfig.testIndex) of \(TestConfig.testListCount)"
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(moveOn)), animated: true)
        
        language = userDefaults.string(forKey: "language")!
        
        let genders = ["Male", "Female", "Other"]
        
        form
            +++ Section("General")
            <<< DateRow(FormItems.birthDate) {
                $0.title = "Birth date"
                $0.value = Date()   
            }
            <<< PushRow<String>(FormItems.gender) {
                $0.title = "Gender"
                $0.options = genders
                $0.value = dataModel.gender
                $0.selectorTitle = "Gender"
                $0.onChange { (row) in
                    if let value = row.value {
                        self.dataModel.gender = value
                    }
                    self.tableView.reloadData()
                }
                }.onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
                }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func moveOn() {
        print(form.values())
        
        
    }
}
