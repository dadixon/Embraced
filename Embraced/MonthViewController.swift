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
    
//    let answersTableView: UITableView = {
//        var tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: "LabelCell")
//        tableView.backgroundColor = .white
//        tableView.tableFooterView = UIView()
//        return tableView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Step \(TestConfig.testIndex) of \(TestConfig.testListCount)"
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        
        language = userDefaults.string(forKey: "language")!
        
//        months = [
//            "January",
//            "February",
//            "March",
//            "April",
//            "May",
//            "June",
//            "July",
//            "August",
//            "September",
//            "October",
//            "November",
//            "December"
//        ]
//
//        answersTableView.delegate = self
//        answersTableView.dataSource = self
//
//        setupViews()
        
        form +++ Section("Section1")
            <<< TextRow(){ row in
                row.title = "Text Row"
                row.placeholder = "Enter text here"
            }
            <<< PhoneRow(){
                $0.title = "Phone Row"
                $0.placeholder = "And numbers here"
            }
        +++ Section("Section2")
            <<< DateRow(){
                $0.title = "Date Row"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }
//        +++ SelectableSection<ListCheckRow<String>>("Where do you live", selectionType: .singleSelection(enableDeselection: true))
//
//        let continents = ["Africa", "Antarctica", "Asia", "Australia", "Europe", "North America", "South America"]
//        for option in continents {
//            form.last! <<< ListCheckRow<String>(option){ listRow in
//                listRow.title = option
//                listRow.selectableValue = option
//                listRow.value = nil
//            }
//        }
//
        +++ Section("Initial")
            <<< PushRow<String>() {
                $0.title = "Month of Birth:"
                $0.options = ["Jan", "Feb", "Mar"]
                $0.selectorTitle = "selectorTitle"
            }.onChange { row in
                print(row.value ?? "No Value")
                
            
            }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    
//    func setupViews() {
//        view.addSubview(answersTableView)
//
//        NSLayoutConstraint.activate([
//            answersTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
//            answersTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
//            answersTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
//            answersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
//        ])
//    }
}

//extension MonthViewController: UITableViewDelegate {
//
//}
//
//extension MonthViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return months.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
//        cell.textLabel?.text = months[indexPath.row]
//
//        return cell
//    }
//
//
//}
