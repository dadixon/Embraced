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
//        "Orientation Task",
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
            TestFiles(name: "eyesTest", data: eyesFiles(), lang: ""),
            TestFiles(name: "matrices", data: matriceFiles(), lang: ""),
            TestFiles(name: "rcft", data: rcftFiles(), lang: ""),
            TestFiles(name: "pitch", data: pitchFiles(), lang: ""),
            TestFiles(name: "digitSpan", data: digitSpanFiles(lang: "en"), lang: "en"),
            TestFiles(name: "digitSpan", data: digitSpanFiles(lang: "es"), lang: "es"),
            TestFiles(name: "stroop", data: stroopFiles(lang: "en"), lang: "en"),
            TestFiles(name: "stroop", data: stroopFiles(lang: "es"), lang: "es"),
            TestFiles(name: "namingTask", data: namingTaskFiles(), lang: ""),
            TestFiles(name: "wordlist", data: wordlistFiles(lang: "en"), lang: "en"),
            TestFiles(name: "wordlist", data: wordlistFiles(lang: "es"), lang: "es"),
            TestFiles(name: "comprehension", data: comprehensionFiles(lang: "en"), lang: "en"),
            TestFiles(name: "comprehension", data: comprehensionFiles(lang: "es"), lang: "es"),
            TestFiles(name: "motorTask", data: motorTaskFiles(), lang: ""),
            TestFiles(name: "trailMaking", data: trailMakingFiles(), lang: "")
        ]
        
        var totalPercentage = 0.0
        var totalFilesCount = 0
        
        for files in downloadFiles {
            totalFilesCount += files.data.count
        }
                
        for testFiles in downloadFiles {
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
    
    private func motorTaskFiles() -> [String] {
        return DataManager.sharedInstance.motorTask
    }
    
    private func trailMakingFiles() -> [String] {
        return DataManager.sharedInstance.trailMaking
    }
    
    private func comprehensionFiles(lang: String) -> [String] {
        DataManager.sharedInstance.language = lang
        DataManager.sharedInstance.updateData()
        
        return DataManager.sharedInstance.comprehensionSounds
    }
    
    private func wordlistFiles(lang: String) -> [String] {
        var wordlistFiles = [String]()
        
        DataManager.sharedInstance.language = lang
        DataManager.sharedInstance.updateData()
        
        wordlistFiles += DataManager.sharedInstance.wordListTasks
        wordlistFiles += DataManager.sharedInstance.wordListRecognitions
        
        return wordlistFiles
    }
    
    private func namingTaskFiles() -> [String] {
        var namingTaskFiles = [String]()
        
        namingTaskFiles += DataManager.sharedInstance.namingTaskPractice
        namingTaskFiles += DataManager.sharedInstance.namingTaskTask
        
        return namingTaskFiles
    }
    
    private func stroopFiles(lang: String) -> [String] {
        var stroopFiles = [String]()
        
        DataManager.sharedInstance.language = lang
        DataManager.sharedInstance.updateData()
        
        stroopFiles += DataManager.sharedInstance.stroopVideos
        stroopFiles += DataManager.sharedInstance.stroopTasks
        
        return stroopFiles
    }
    
    private func digitSpanFiles(lang: String) -> [String] {
        var digitSpan = [String]()
        
        DataManager.sharedInstance.language = lang
        DataManager.sharedInstance.updateData()

        digitSpan.append(DataManager.sharedInstance.digitalSpanForwardPractice)
        digitSpan.append(DataManager.sharedInstance.digitalSpanBackwardPractice)
        digitSpan += DataManager.sharedInstance.digitalSpanForward
        digitSpan += DataManager.sharedInstance.digitalSpanBackward
        
        return digitSpan
    }
    
    private func pitchFiles() -> [String] {
        var pitchFiles = [String]()
        
        for file in DataManager.sharedInstance.pitchExamples {
            pitchFiles += file
        }
        
        for file in DataManager.sharedInstance.pitchPractices {
            pitchFiles += file
        }
        
        for file in DataManager.sharedInstance.pitchTasks {
            pitchFiles += file
        }
        
        return pitchFiles
    }
    
    private func eyesFiles() -> [String] {
        return DataManager.sharedInstance.eyesTestImages
    }
    
    private func matriceFiles() -> [String] {
        var matricesFiles = [String]()
        
        for task in DataManager.sharedInstance.matricesStimuli {
            matricesFiles.append(task.displayImageName)
            
            for choice in task.choices {
                matricesFiles.append(choice)
            }
        }
        
        return matricesFiles
    }
    
    private func rcftFiles() -> [String] {
        var rcftFiles = [String]()
        
        rcftFiles = DataManager.sharedInstance.rcftTasks
        rcftFiles.append(DataManager.sharedInstance.rcftFigure)
        
        return rcftFiles
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
