//
//  MoCATaskViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 3/24/20.
//  Copyright © 2020 Domonique Dixon. All rights reserved.
//

import UIKit
import Eureka

class MoCATaskViewController: FormViewController {

    let userDefaults = UserDefaults.standard
    var language = String()
    var dataModel = MoCAModel.shared
    var month = String()
    var date = Int()
    var weekday = String()
    var hour = Int()
    var minute = Int()
    var ampm = String()
    
    var weekdays = [String]()
    var months = [String]()
    
    struct FormItems {
        static let year = "year"
        static let month = "month"
        static let date = "date"
        static let weekday = "weekday"
        static let hour = "hour"
        static let minute = "minute"
        static let ampm = "ampm"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        language = userDefaults.string(forKey: "language")!
        
        title = "moca_current_time_title".localized(lang: language)
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Next".localized(lang: language), style: .done, target: self, action: #selector(moveOn)), animated: true)
        
        weekdays = [
            "moca_sunday".localized(lang: language),
            "moca_monday".localized(lang: language),
            "moca_tuesday".localized(lang: language),
            "moca_wednesday".localized(lang: language),
            "moca_thursday".localized(lang: language),
            "moca_friday".localized(lang: language),
            "moca_saturday".localized(lang: language),
        ]
        
        months = [
            "moca_january".localized(lang: language),
            "moca_february".localized(lang: language),
            "moca_march".localized(lang: language),
            "moca_april".localized(lang: language),
            "moca_may".localized(lang: language),
            "moca_june".localized(lang: language),
            "moca_july".localized(lang: language),
            "moca_august".localized(lang: language),
            "moca_september".localized(lang: language),
            "moca_october".localized(lang: language),
            "moca_november".localized(lang: language),
            "moca_december".localized(lang: language)
        ]
        
        form
            +++ Section("moca_year".localized(lang: language))
                <<< IntRow(FormItems.year){ row in
                    row.title = "moca_year_title".localized(lang: language)
                    row.placeholder = "moca_year_placeholder".localized(lang: language)
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .systemRed
                        cell.layer.borderColor = UIColor.systemRed.cgColor
                    }
                }
            +++ Section("moca_month".localized(lang: language))
                <<< PushRow<String>(FormItems.month) { row in
                    row.title = "moca_month_title".localized(lang: language)
                    row.options = months
                    row.value = month
                    row.selectorTitle = "moca_month_title".localized(lang: language)
                    row.onChange { (row) in
                        if let value = row.value {
                            self.month = value
                        }
                        self.tableView.reloadData()
                    }
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }.onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .systemRed
                        cell.layer.borderColor = UIColor.systemRed.cgColor
                    }
                }
            +++ Section("moca_date".localized(lang: language))
                <<< PickerInputRow<Int>(FormItems.date) { row in
                    row.title = "moca_date_title".localized(lang: language)
                    row.options = []
                    for i in 1...31{
                        row.options.append(i)
                    }
                    row.value = date
                    row.onChange { (row) in
                        if let value = row.value {
                            self.date = value
                        }
                        self.tableView.reloadData()
                    }
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .systemRed
                        cell.layer.borderColor = UIColor.systemRed.cgColor
                    }
                }
            +++ Section("moca_day".localized(lang: language))
                <<< PushRow<String>(FormItems.weekday) { row in
                    row.title = "moca_day_title".localized(lang: language)
                    row.options = weekdays
                    row.value = weekday
                    row.selectorTitle = "moca_weekday_title".localized(lang: language)
                    row.onChange { (row) in
                        if let value = row.value {
                            self.weekday = value
                        }
                        self.tableView.reloadData()
                    }
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }.onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .systemRed
                        cell.layer.borderColor = UIColor.systemRed.cgColor
                    }
                }
            +++ Section("moca_time".localized(lang: language))
                <<< PickerInputRow<Int>(FormItems.hour){
                    $0.title = "moca_hour_title".localized(lang: language)
                    $0.options = []
                    for i in 1...12{
                        $0.options.append(i)
                    }
                    $0.value = hour
                    $0.onChange { (row) in
                        if let value = row.value {
                            self.hour = value
                        }
                        self.tableView.reloadData()
                    }
                    $0.add(rule: RuleRequired())
                    $0.add(rule: RuleGreaterThan(min: 0))
                    $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .systemRed
                        cell.layer.borderColor = UIColor.systemRed.cgColor
                    }
                }
                <<< PickerInputRow<Int>(FormItems.minute){
                    $0.title = "moca_minute_title".localized(lang: language)
                    $0.options = []
                    for i in 0...59{
                        $0.options.append(i)
                    }
                    $0.value = minute
                    $0.onChange { (row) in
                        if let value = row.value {
                            self.minute = value
                        }
                        self.tableView.reloadData()
                    }
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .systemRed
                        cell.layer.borderColor = UIColor.systemRed.cgColor
                    }
                }
                <<< PushRow<String>(FormItems.ampm) { row in
                    row.title = "AM/PM"
                    row.options = ["AM", "PM"]
                    row.value = ampm
                    row.selectorTitle = "AM/PM"
                    row.onChange { (row) in
                        if let value = row.value {
                            self.ampm = value
                        }
                        self.tableView.reloadData()
                    }
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }.onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .systemRed
                        cell.layer.borderColor = UIColor.systemRed.cgColor
                    }
                }
    }
    
    @objc func moveOn() {
        if form.validate().count == 0 {
            let values = form.values()
            
            if let weekday = weekdays.index(of: weekday),
                let month = months.index(of: month) {
                dataModel.date = Date()
                dataModel.userYear = values["year"] as? Int
                dataModel.userMonth = month + 1
                dataModel.userDate = values["date"] as? Int
                dataModel.userWeekday = weekday + 1
                dataModel.userHour = values["hour"] as? Int
                dataModel.userMinute = values["minute"] as? Int
                dataModel.userAMPM = values["ampm"] as? String

                FirebaseStorageManager.shared.addDataToDocument(payload: ["moca": dataModel.getModel()])

                let vc = MoCAInstructions2ViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}
