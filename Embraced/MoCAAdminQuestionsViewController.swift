//
//  MoCAAdminQuestionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 3/24/20.
//  Copyright © 2020 Domonique Dixon. All rights reserved.
//

import UIKit
import Eureka

class MoCAAdminQuestionsViewController: FormViewController {

    let userDefaults = UserDefaults.standard
    var language = String()
    var dataModel = MoCAModel.shared
    var month = String()
    var date = Int()
    var weekday = String()
    var hour = Int()
    var minute = Int()
    var ampm = String()
    
    struct FormItems {
        static let country = "country"
        static let county = "county"
        static let city = "city"
        static let location = "location"
        static let floor = "floor"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MoCA Admin"
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(moveOn)), animated: true)
        
        language = userDefaults.string(forKey: "language")!
        
        form
            +++ Section("What country are you in?")
                <<< TextRow(FormItems.country){ row in
                    row.title = "Country"
                    row.placeholder = "Enter country here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .systemRed
                    }
                }
            +++ Section("What county are you in?")
                <<< TextRow(FormItems.county){ row in
                    row.title = "County"
                    row.placeholder = "Enter county here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .systemRed
                    }
                }
            +++ Section("What city or town are you in?")
                <<< TextRow(FormItems.city){ row in
                    row.title = "City"
                    row.placeholder = "Enter city or town here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .systemRed
                    }
                }
            +++ Section("What type of site or location are you in?")
                <<< TextRow(FormItems.location){ row in
                    row.title = "Location"
                    row.placeholder = "Enter location here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .systemRed
                    }
                }
            +++ Section("What floor are you on?")
                <<< TextRow(FormItems.floor){ row in
                    row.title = "Floor"
                    row.placeholder = "Enter floor here"
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .systemRed
                    }
                }
    }
    
    @objc func moveOn() {
        if form.validate().count == 0 {
            let values = form.values()
            
            dataModel.date = Date()
            dataModel.realCountry = values["country"] as? String
            dataModel.realCounty = values["county"] as? String
            dataModel.realCity = values["city"] as? String
            dataModel.realLocation = values["location"] as? String
            dataModel.realFloor = values["floor"] as? String

            FirebaseStorageManager.shared.addDataToDocument(payload: ["moca": dataModel.getModel()])
            
            let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "startTest") as? StartViewController)!
            let nvc = UINavigationController(rootViewController: vc)
            
            self.present(nvc, animated: true) {
                self.navigationController?.popViewController(animated: false)
            }
        }
        
        
    }

}
