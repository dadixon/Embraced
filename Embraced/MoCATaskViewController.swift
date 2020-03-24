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

        title = "Current Time"
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(moveOn)), animated: true)
        
        language = userDefaults.string(forKey: "language")!
        
        form
            +++ Section("What is the year? ie: 1999")
                <<< TextRow(FormItems.year){ row in
                    row.title = "Year"
                    row.placeholder = "Enter year here"
                }
            +++ Section("What is the month?")
                <<< PushRow<String>(FormItems.month) { row in
                    row.title = "Month"
                    row.options = Calendar.current.monthSymbols
                    row.value = month
                    row.selectorTitle = "Month"
                    row.onChange { (row) in
                        if let value = row.value {
                            self.month = value
                        }
                        self.tableView.reloadData()
                    }
                }.onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
                }
            +++ Section("What is the date?")
                <<< PickerInputRow<Int>(FormItems.date) { row in
                    row.title = "Date"
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
                }
            +++ Section("What day is it today?")
                <<< PushRow<String>(FormItems.weekday) { row in
                    row.title = "Day"
                    row.options = Calendar.current.weekdaySymbols
                    row.value = weekday
                    row.selectorTitle = "Weekday"
                    row.onChange { (row) in
                        if let value = row.value {
                            self.weekday = value
                        }
                        self.tableView.reloadData()
                    }
                }.onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
                }
            +++ Section("What time is it approximately?")
                <<< PickerInputRow<Int>(FormItems.hour){
                    $0.title = "Hour"
                    $0.options = []
                    for i in 1...12{
                        $0.options.append(i)
                    }
                    $0.value = $0.options.first
                    $0.onChange { (row) in
                        if let value = row.value {
                            self.hour = value
                        }
                        self.tableView.reloadData()
                    }
                }
                <<< PickerInputRow<Int>(FormItems.minute){
                    $0.title = "Minutes"
                    $0.options = []
                    for i in 0...59{
                        $0.options.append(i)
                    }
                    $0.value = $0.options.first
                    $0.onChange { (row) in
                        if let value = row.value {
                            self.minute = value
                        }
                        self.tableView.reloadData()
                    }
                }
                <<< PushRow<String>(FormItems.ampm) { row in
                    row.title = "AM/PM"
                    row.options = ["AM", "PM"]
                    row.value = weekday
                    row.selectorTitle = "AM/PM"
                    row.onChange { (row) in
                        if let value = row.value {
                            self.weekday = value
                        }
                        self.tableView.reloadData()
                    }
                }.onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
                }
    }
    
    @objc func moveOn() {
        print(form.values())
        // Save data
        
        
        let vc = MoCATask2ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
//        let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "startTest") as? StartViewController)!
//        let nvc = UINavigationController(rootViewController: vc)
//
//        self.present(nvc, animated: true) {
//
//        }
    }

}
