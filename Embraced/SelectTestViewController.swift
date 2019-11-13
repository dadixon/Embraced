//
//  SelectTestViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 5/28/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import SVProgressHUD

class SelectTestViewController: UIViewController {
    
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var deselectAllBtn: UIButton!
    @IBOutlet weak var startBtn: UIBarButtonItem!
    @IBOutlet weak var testTableView: UITableView!
    
    let userDefaults = UserDefaults.standard
    var language = String()
    var selectedTests = [String]()
    var tests = [
//        "Questionnaire",
//        "Orientation Task",
        "Complex Figure 1",
        "Clock Drawing Test",
        "Complex Figure 2",
        "Trail Making Test",
        "Melodies Recognition",
        "Digit Span",
        "Complex Figure 3",
        "Complex Figure 4",
//        "Matrices",
//        "Continuous Performance Test",
//        "Motor Tasks",
        "Word List 1",
        "Color-Word Stroop Test",
        "Cancellation Test",
        "Word List 2",
        "Naming Test",
        "Comprehension Task",
        "Eyes Test"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        selectAllBtn.setTitle("Select All", for: .normal)
        deselectAllBtn.setTitle("De-Select All", for: .normal)
        
        testTableView.delegate = self
        testTableView.dataSource = self
        testTableView.tableFooterView = UIView()
        
        SVProgressHUD.setDefaultStyle(.dark)
    }
    
    private func setupNav() {
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        title = "Select Tests"
        
        startBtn.title = "Start Test"
    }

    private func buildTestList() {
        TestConfig.shared.testListName = selectedTests
    }
    
    @IBAction func selectAllPressed(_ sender: Any) {
    }
    
    @IBAction func deselectAllPressed(_ sender: Any) {
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        buildTestList()
        
        if (TestConfig.shared.testList.count == 0) {
            SVProgressHUD.showError(withStatus: "Please select a test.")
            return
        }
        
        self.userDefaults.setValue("testing", forKey: "pid")
        
        FirebaseStorageManager.shared.pid = self.userDefaults.string(forKey: "pid")!
//        FirebaseStorageManager.shared.createParticipantDocument()
        
        let alertController = UIAlertController(title: "Participant_ID".localized(lang: self.language), message: "asdfdsadf", preferredStyle: UIAlertController.Style.alert)
        
        self.present(alertController, animated: true, completion: nil)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
            
            // TODO: If Moca test is selected, show the moca test inputs
            self.performSegue(withIdentifier: "moveToLanguages", sender: self)
        }
        
        alertController.addAction(dismissAction)
    }
}

extension SelectTestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTests.append(tests[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        for i in 0..<selectedTests.count {
            if selectedTests[i] == tests[indexPath.row] {
                selectedTests.remove(at: i)
                break
            }
        }
    }
}

extension SelectTestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath)
        cell.textLabel?.text = tests[indexPath.row]
        
        return cell
    }
}
