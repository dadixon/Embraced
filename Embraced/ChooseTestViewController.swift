//
//  ChooseTestViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/21/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class ChooseTestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var confirmListLabel: UILabel!
    @IBOutlet weak var testListLabel: UILabel!
    @IBOutlet weak var testListTable: UITableView!
    @IBOutlet weak var confirmListTable: UITableView!
    @IBOutlet weak var saveBtn: NavigationButton!
    
    
    var tests = ["Questionnaire", "MOCA", "RCF1", "ClockDrawing", "RCF2", "TrailMaking", "Pitch", "DigitalSpan", "RCF3", "RCF4", "CPT", "Matrices", "Pegboard", "WordList1", "Stroop", "Cancellation", "WordList2", "NamingTask", "Comprehension", "EyeTest"]
    var confirm = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.testListTable.register(UITableViewCell.self, forCellReuseIdentifier: "cellTest")
        self.confirmListTable.register(UITableViewCell.self, forCellReuseIdentifier: "cellConfirm")
        
        testListTable.tableFooterView = UIView(frame: .zero)
        confirmListTable.tableFooterView = UIView(frame: .zero)
        
        confirmListTable.setEditing(true, animated: true)
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
            count = tests.count
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
            
            cell.textLabel?.text = tests[indexPath.row]
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
            confirm.insert(tests[indexPath.row], at: confirm.count)
            self.confirmListTable.beginUpdates()
            self.confirmListTable.insertRows(at: [IndexPath.init(row: self.confirm.count-1, section: 0)], with: .left)
            self.confirmListTable.endUpdates()
            
            // Remove from test list table
            tests.remove(at: indexPath.row)
            self.testListTable.beginUpdates()
            self.testListTable.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: .right)
            self.testListTable.endUpdates()
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Add row to test list table and delete from confirm table
        if editingStyle == .delete {
            tests.insert(confirm[indexPath.row], at: 0)
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
    
    
    // MARK: Action
    
    @IBAction func saveTestList(_ sender: Any) {
        let participant = UserDefaults.standard
        
        participant.set(confirm, forKey: "Tests")
        
        let vc = UserInputViewController()
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
}
