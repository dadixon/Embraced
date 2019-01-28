 //
//  SettingsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/21/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import Alamofire
 
class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var testListTable: UITableView!
    @IBOutlet weak var confirmListTable: UITableView!
    @IBOutlet weak var languageSegment: UISegmentedControl!
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var deselectAllBtn: UIButton!
    @IBOutlet weak var chooseLanguage: UILabel!
    
    var tests = [
        "Questionnaire",
        "Orientation Task",
        "Complex Figure 1",
        "Clock Drawing Test",
        "Complex Figure 2",
        "Trail Making Test",
        "Melodies Recognition",
        "Digit Span",
        "Complex Figure 3",
        "Complex Figure 4",
        "Matrices",
        "Continuous Performance Test",
        "Motor Tasks",
        "Word List 1",
        "Color-Word Stroop Test",
        "Cancellation Test",
        "Word List 2",
        "Naming Test",
        "Comprehension Task",
        "Eyes Test"
    ]
    
    var defaultTests = [String]()
    var confirm = [String]()
    
    let participant = UserDefaults.standard
    var testerLanguage = ""
    let APIUrl = "http://www.embracedapi.ugr.es/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.testListTable.register(UITableViewCell.self, forCellReuseIdentifier: "cellTest")
        self.confirmListTable.register(UITableViewCell.self, forCellReuseIdentifier: "cellConfirm")
        
        testListTable.tableFooterView = UIView(frame: .zero)
        confirmListTable.tableFooterView = UIView(frame: .zero)
        
        confirmListTable.setEditing(true, animated: true)
        defaultTests = tests
        
        if participant.array(forKey: "Tests") != nil {
            confirm = participant.array(forKey: "Tests") as! [String]
            confirm = confirm.filter {tests.contains($0)}
        }
        
        defaultTests = defaultTests.filter {!confirm.contains($0)}
        
        confirmListTable.reloadData()
        testListTable.reloadData()
        
        var testerLanguage = participant.string(forKey: "TesterLanguage")
        
        if testerLanguage != nil {
            if testerLanguage == "en" {
                languageSegment.selectedSegmentIndex = 0
            } else if testerLanguage == "es" {
                languageSegment.selectedSegmentIndex = 1
            }
        } else {
          languageSegment.selectedSegmentIndex = 0
            testerLanguage = "en"
        }
        
        self.navigationController?.isNavigationBarHidden = true
        setControllerLanguage(testerLanguage!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setControllerLanguage(_ language: String) {
        selectAllBtn.setTitle("Select_All".localized(lang: language), for: .normal)
        deselectAllBtn.setTitle("Deselect_All".localized(lang: language), for: .normal)
        chooseLanguage.text = "Choose_Language".localized(lang: language)
        self.tabBarController?.tabBar.items![0].title = "Test".localized(lang: language)
        self.tabBarController?.tabBar.items![1].title = "Settings".localized(lang: language)
    }
    
    
    
    // MARK: Table Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int!
        
        if tableView == self.testListTable {
            count = defaultTests.count
        }
        
        if tableView == self.confirmListTable {
            count = confirm.count
        }
        
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if tableView == self.testListTable {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellTest", for: indexPath)
            
            cell.textLabel?.text = defaultTests[indexPath.row].uppercased()
        }
        
        if tableView == self.confirmListTable {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellConfirm", for: indexPath)
            
            cell.textLabel?.text = confirm[indexPath.row].uppercased()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.testListTable {
            // Add to confirm table with animation
            confirm.insert(defaultTests[indexPath.row], at: confirm.count)
            self.confirmListTable.beginUpdates()
            self.confirmListTable.insertRows(at: [IndexPath.init(row: self.confirm.count-1, section: 0)], with: .left)
            self.confirmListTable.endUpdates()
            
            // Remove from test list table
            defaultTests.remove(at: indexPath.row)
            self.testListTable.beginUpdates()
            self.testListTable.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: .right)
            self.testListTable.endUpdates()
            saveSettings()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Add row to test list table and delete from confirm table
        if editingStyle == .delete {
            defaultTests.insert(confirm[indexPath.row], at: 0)
            self.testListTable.beginUpdates()
            self.testListTable.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .right)
            self.testListTable.endUpdates()
            
            confirm.remove(at: indexPath.row)
            self.confirmListTable.beginUpdates()
            self.confirmListTable.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: .fade)
            self.confirmListTable.endUpdates()
            saveSettings()
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        confirm.insert(confirm.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
        confirmListTable.reloadData()
        saveSettings()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var rv = ""
        
        if tableView == self.testListTable {
            rv = "Test_List".localized(lang: participant.string(forKey: "TesterLanguage")!)
        } else if tableView == self.confirmListTable {
            rv = "Your_Test".localized(lang: participant.string(forKey: "TesterLanguage")!)
        }
        
        return rv
    }
    
    // MARK: Action
    
    func saveSettings() {
        participant.set(confirm, forKey: "Tests")
        
        if testerLanguage != "" {
            participant.setValue(testerLanguage, forKey: "TesterLanguage")
        } else {
            participant.setValue("en", forKey: "TesterLanguage")
        }

        setControllerLanguage(participant.string(forKey: "TesterLanguage")!)
        
        self.testListTable.reloadData()
        self.confirmListTable.reloadData()
        
//        var alertController = UIAlertController()
//
//        alertController = UIAlertController(title: "Saved".localized(lang: participant.string(forKey: "TesterLanguage")!), message: "Save_settings".localized(lang: participant.string(forKey: "TesterLanguage")!), preferredStyle: UIAlertControllerStyle.alert)
//
//        let dismissAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
//            alertController.dismiss(animated: true, completion: nil)
//        }
//
//        alertController.addAction(dismissAction)
//        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deselectAllTest(_ sender: Any) {
        defaultTests = tests
        confirm = []
        testListTable.reloadData()
        confirmListTable.reloadData()
        saveSettings()
    }
    
    @IBAction func selectAllTest(_ sender: Any) {
        confirm = tests
        defaultTests = []
        testListTable.reloadData()
        confirmListTable.reloadData()
        saveSettings()
    }
    
    @IBAction func languageChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            testerLanguage = "en"
        } else if sender.selectedSegmentIndex == 1 {
            testerLanguage = "es"
        }
        
        setControllerLanguage(testerLanguage)
        saveSettings()
    }
}
