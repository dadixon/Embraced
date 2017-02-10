//
//  SettingsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/21/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var testListTable: UITableView!
    @IBOutlet weak var confirmListTable: UITableView!
    @IBOutlet weak var saveBtn: NavigationButton!
    @IBOutlet weak var languageSegment: UISegmentedControl!
    
    
    let tests = ["Questionnaire", "MOCA", "RCF1", "ClockDrawing", "RCF2", "TrailMaking", "Pitch", "DigitalSpan", "RCF3", "RCF4", "CPT", "Matrices", "Pegboard", "WordList1", "Stroop", "Cancellation", "WordList2", "NamingTask", "Comprehension", "EyeTest"]
    var defaultTests = [String]()
    var confirm = [String]()
    
    let participant = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.testListTable.register(UITableViewCell.self, forCellReuseIdentifier: "cellTest")
        self.confirmListTable.register(UITableViewCell.self, forCellReuseIdentifier: "cellConfirm")
        
        testListTable.tableFooterView = UIView(frame: .zero)
        confirmListTable.tableFooterView = UIView(frame: .zero)
        
        confirmListTable.setEditing(true, animated: true)
        
        if participant.array(forKey: "Tests") != nil {
            confirm = participant.array(forKey: "Tests") as! [String]
            
            defaultTests = tests
            
            for test in confirm {
                defaultTests = defaultTests.filter {$0 != test}
            }
        }
        
        let testerLanguage = participant.string(forKey: "TesterLanguage")
        
        if testerLanguage != nil {
            if testerLanguage == "Engligh" {
                languageSegment.selectedSegmentIndex = 0
            } else if testerLanguage == "Español" {
                languageSegment.selectedSegmentIndex = 1
            }
        } else {
          languageSegment.selectedSegmentIndex = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            cell.textLabel?.text = defaultTests[indexPath.row]
        }
        
        if tableView == self.confirmListTable {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellConfirm", for: indexPath)
            
            cell.textLabel?.text = confirm[indexPath.row]
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
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        confirm.insert(confirm.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
        confirmListTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var rv = ""
        
        if tableView == self.testListTable {
            rv = "Test List"
        } else if tableView == self.confirmListTable {
            rv = "Your Test"
        }
        
        return rv
    }
    
    // MARK: Action
    
    @IBAction func saveTestList(_ sender: Any) {
        participant.set(confirm, forKey: "Tests")
        
        var alertController = UIAlertController()
        
        alertController = UIAlertController(title: "Saved", message: "Your test settings are saved.", preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deselectAllTest(_ sender: Any) {
        defaultTests = tests
        confirm = []
        testListTable.reloadData()
        confirmListTable.reloadData()
    }
    
    @IBAction func selectAllTest(_ sender: Any) {
        confirm = tests
        defaultTests = []
        testListTable.reloadData()
        confirmListTable.reloadData()
    }
    
    @IBAction func languageChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            participant.set("English", forKey: "TesterLanguage")
        } else if sender.selectedSegmentIndex == 1 {
            participant.set("Español", forKey: "TesterLanguage")
        }
    }
}
