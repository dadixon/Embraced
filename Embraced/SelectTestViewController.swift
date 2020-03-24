//
//  SelectTestViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 5/28/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import SVProgressHUD

struct TestFiles {
    var name: String
    var data: [String]
    var lang: String
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        selectAllBtn.setTitle("Select All", for: .normal)
        deselectAllBtn.setTitle("De-Select All", for: .normal)
        
        testTableView.delegate = self
        testTableView.dataSource = self
        testTableView.tableFooterView = UIView()
        
        SVProgressHUD.setDefaultStyle(.dark)
        
        DataManager.sharedInstance.updateData()
        
        downloadFiles()
    }
    
    private func setupNav() {
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        title = "Select Tests"
        
        startBtn.title = "Start Test"
    }

    private func downloadFiles() {
        let downloadFiles = [
            TestFiles(name: "eyesTest", data: DataManager.sharedInstance.eyesFiles(), lang: ""),
            TestFiles(name: "matrices", data: DataManager.sharedInstance.matriceFiles(), lang: ""),
            TestFiles(name: "rcft", data: DataManager.sharedInstance.rcftFiles(), lang: ""),
            TestFiles(name: "pitch", data: DataManager.sharedInstance.pitchFiles(), lang: ""),
            TestFiles(name: "digitSpan", data: DataManager.sharedInstance.digitSpanFiles(lang: "en"), lang: "en"),
            TestFiles(name: "digitSpan", data: DataManager.sharedInstance.digitSpanFiles(lang: "es"), lang: "es"),
            TestFiles(name: "stroop", data: DataManager.sharedInstance.stroopFiles(lang: "en"), lang: "en"),
            TestFiles(name: "stroop", data: DataManager.sharedInstance.stroopFiles(lang: "es"), lang: "es"),
            TestFiles(name: "namingTask", data: DataManager.sharedInstance.namingTaskFiles(), lang: ""),
            TestFiles(name: "wordlist", data: DataManager.sharedInstance.wordlistFiles(lang: "en"), lang: "en"),
            TestFiles(name: "wordlist", data: DataManager.sharedInstance.wordlistFiles(lang: "es"), lang: "es"),
            TestFiles(name: "comprehension", data: DataManager.sharedInstance.comprehensionFiles(lang: "en"), lang: "en"),
            TestFiles(name: "comprehension", data: DataManager.sharedInstance.comprehensionFiles(lang: "es"), lang: "es"),
            TestFiles(name: "motorTask", data: DataManager.sharedInstance.motorTaskFiles(), lang: ""),
            TestFiles(name: "trailMaking", data: DataManager.sharedInstance.trailMakingFiles(), lang: "")
        ]
        
        var totalPercentage = 0.0
        var totalFilesCount = 0
        let totalFiles = Utility.getDownloadList(files: downloadFiles)
        
        for files in totalFiles {
            totalFilesCount += files.data.count
        }
                
        for testFiles in totalFiles {
            for name in testFiles.data {
                FirebaseStorageManager.shared.getFile(fileName: name, test: testFiles.name, lang: testFiles.lang) { (percentComplete, error) in
                    
                    if percentComplete == 1.0 {
                        totalPercentage += percentComplete

                        let percentage = Float(totalPercentage * 100.0) / Float(totalFilesCount) / 100.0
                        SVProgressHUD.showProgress(percentage, status: "Loading...")
                        
                        if Int(totalPercentage) == totalFilesCount {
                            SVProgressHUD.dismiss()
                        }
                    }
                    
                }
            }
        }
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
            
            if TestConfig.shared.testListName.contains("Orientation Task") {
                let vc = MoCAAdminQuestionsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.performSegue(withIdentifier: "moveToLanguages", sender: self)
            }
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
