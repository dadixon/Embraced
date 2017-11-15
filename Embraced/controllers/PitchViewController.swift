//
//  PitchViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class PitchViewController: FrontViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var introView: UIView!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var introBtn: NavigationButton!
    
    @IBOutlet var example1View: UIView!
    @IBOutlet weak var example1: UILabel!
    @IBOutlet weak var example1Content: UILabel!
    @IBOutlet weak var example1Response: UILabel!
    @IBOutlet weak var example1Label: UILabel!
    @IBOutlet weak var example1segment: UISegmentedControl!
    @IBOutlet weak var example1btn: NavigationButton!
    
    @IBOutlet var example2View: UIView!
    @IBOutlet weak var example2: UILabel!
    @IBOutlet weak var example2Content: UILabel!
    @IBOutlet weak var example2Response: UILabel!
    @IBOutlet weak var example2Label: UILabel!
    @IBOutlet weak var example2segment: UISegmentedControl!
    @IBOutlet weak var example2btn: NavigationButton!
    
    @IBOutlet var example3View: UIView!
    @IBOutlet weak var example3: UILabel!
    @IBOutlet weak var example3Content: UILabel!
    @IBOutlet weak var example3Response: UILabel!
    @IBOutlet weak var example3Label: UILabel!
    @IBOutlet weak var example3segment: UISegmentedControl!
    @IBOutlet weak var example3btn: NavigationButton!
    
    @IBOutlet var trial1View: UIView!
    @IBOutlet weak var practiceLabel: UILabel!
    @IBOutlet weak var practiceInstructionsLabel: UILabel!
    @IBOutlet weak var practiceResponse: UILabel!
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var practiceSegment: UISegmentedControl!
    @IBOutlet weak var practiceBtn: NavigationButton!
    
    @IBOutlet var preTaskView: UIView!
    @IBOutlet weak var tasksContent: UILabel!
    @IBOutlet weak var pretaskBtn: NavigationButton!
    
    @IBOutlet var taskView: UIView!
    @IBOutlet weak var taskResponse: UILabel!
    @IBOutlet weak var tasksLabel: UILabel!
    @IBOutlet weak var taskSegment: UISegmentedControl!
    @IBOutlet weak var taskBtn: NavigationButton!
    
    @IBOutlet var completeView: UIView!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    var stimuli = [String: Any]()
    var examples = [[String]]()
    var tasks = [[String]]()
    var practices = [[String]]()
    
    let exampleAnswers = ["S", "D", "D"]
    let practiceAnswers = ["D", "D", "S", "D", "D"]
    let taskAnswers = ["S", "D", "S", "D", "D", "S", "D", "S", "D", "D", "S", "S", "S", "S", "D", "D", "D", "D", "D", "S", "S", "S", "S", "D"]
    
    var userAnswers = [String]()
    
    var firstSound = String()
    var secondSound = String()
    var soundLabel = UILabel()
    var played = false
    
    var exampleCount = 0
    var taskCount = 0
    var practiceCount = 0
    var position = 0
    
    var timer = Timer()
    let APIUrl = "http://www.embracedapi.ugr.es/"
    let userDefaults = UserDefaults.standard
    var token: String = ""
    var id: String = ""
    var headers: HTTPHeaders = [:]
    
    let group = DispatchGroup()
    
    // MARK: - Private
    
    private func log(logMessage: String, functionName: String = #function) {
        print("\(functionName): \(logMessage)")
    }
    
    private func setSubview(_ current: UIView, next: UIView) {
        
        current.removeFromSuperview()
        containerView.addSubview(next)
        
        let leftConstraint = next.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let topConstraint = next.topAnchor.constraint(equalTo: containerView.topAnchor)
        let rightConstraint = next.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottomConstraint = next.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
    }
    
    override func viewDidLoad() {
        step = AppDelegate.position
        
        super.viewDidLoad()
        
        language = participant.string(forKey: "language")!
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(PitchViewController.next(_:)))
        
        showOrientationAlert(orientation: "portrait")
        
        introView.translatesAutoresizingMaskIntoConstraints = false
        example1View.translatesAutoresizingMaskIntoConstraints = false
        example2View.translatesAutoresizingMaskIntoConstraints = false
        example3View.translatesAutoresizingMaskIntoConstraints = false
        trial1View.translatesAutoresizingMaskIntoConstraints = false
        preTaskView.translatesAutoresizingMaskIntoConstraints = false
        taskView.translatesAutoresizingMaskIntoConstraints = false
        completeView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(introView)
        
        let leftConstraint = introView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let topConstraint = introView.topAnchor.constraint(equalTo: containerView.topAnchor)
        let rightConstraint = introView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottomConstraint = introView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
        
        // Fetch audios
        // New way by downloading files instead of using native ones
        id = participant.string(forKey: "pid")!
        token = userDefaults.string(forKey: "token")!
        headers = [
            "x-access-token": token
        ]
        
        examples = DataManager.sharedInstance.pitchExamples
        practices = DataManager.sharedInstance.pitchPractices
        tasks = DataManager.sharedInstance.pitchTasks
        
        introBtn.setTitle("Start".localized(lang: language), for: .normal)
        introLabel.text = "pitch_intro".localized(lang: language)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func updateTime() {
        if self.played == false {
            self.soundLabel.text = "2"
            play(secondSound)
            
            resetTimer()
        }
        
        self.played = true
    }
    
    private func startTimer() {
        if !timer.isValid {
            let aSelector : Selector = #selector(PitchViewController.updateTime)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
        }
    }
    
    private func resetTimer() {
        timer.invalidate()
    }
    
    private func setupSounds(_ soundArray: Array<Array<String>>, iterator: Int, label: UILabel) {
        if soundPlayer != nil {
            if (soundPlayer?.isPlaying)! {
                soundPlayer?.stop()
            }
        }
        
        played = false
        resetTimer()
        
        if soundArray[iterator].count > 1 {
            firstSound = soundArray[iterator][1]
            secondSound = soundArray[iterator][0]
        } else if soundArray[iterator].count == 1 {
            firstSound = soundArray[iterator][0]
            secondSound = soundArray[iterator][0]
        }
        
        soundLabel = label
        soundLabel.text = ""
    }
    
    func setupExample1() {
        example1.text = "Example".localized(lang: language) + " 1"
        example1Content.text = "pitch_example_1".localized(lang: language)
        example1btn.setTitle("Next".localized(lang: language), for: .normal)
        example1segment.setTitle("Same".localized(lang: language), forSegmentAt: 0)
        example1segment.setTitle("Different".localized(lang: language), forSegmentAt: 1)
        
        example1btn.isHidden = true
        example1segment.isHidden = true
    }
    
    func setupExample2() {
        example2.text = "Example".localized(lang: language) + " 2"
        example2Content.text = "pitch_example_2".localized(lang: language)
        example2btn.setTitle("Next".localized(lang: language), for: .normal)
        example2segment.setTitle("Same".localized(lang: language), forSegmentAt: 0)
        example2segment.setTitle("Different".localized(lang: language), forSegmentAt: 1)
        
        example2btn.isHidden = true
        example2segment.isHidden = true
    }
    
    func setupExample3() {
        example3.text = "Example".localized(lang: language) + " 3"
        example3Content.text = "pitch_example_3".localized(lang: language)
        example3btn.setTitle("Next".localized(lang: language), for: .normal)
        example3segment.setTitle("Same".localized(lang: language), forSegmentAt: 0)
        example3segment.setTitle("Different".localized(lang: language), forSegmentAt: 1)
        
        example3btn.isHidden = true
        example3segment.isHidden = true
    }
    
    func setupPractice1() {
        practiceLabel.text = "Practice".localized(lang: language) + " " + String(practiceCount+1)
        practiceInstructionsLabel.text = "pitch_practice_1".localized(lang: language)
        practiceSegment.setTitle("Same".localized(lang: language), forSegmentAt: 0)
        practiceSegment.setTitle("Different".localized(lang: language), forSegmentAt: 1)
        practiceBtn.setTitle("Next".localized(lang: language), for: .normal)
        
        practiceSegment.isHidden = true
        practiceBtn.isHidden = true
    }

    func createPostObject() -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        
        // Gather data for post
        jsonObject = [
            "answers": userAnswers as AnyObject
        ]
        
        return jsonObject
    }
    
    func postToAPI() {
        let headers: HTTPHeaders = [
            "x-access-token": token
        ]
        
        Alamofire.request(APIUrl + "api/pitch/new/" + id, method: .post, parameters: createPostObject(), encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//            debugPrint(response)
            let statusCode = response.response?.statusCode
            
            if statusCode == 200 {
                self.hideOverlayView()
                self.next(self)
            }
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        AppDelegate.position += 1
        AppDelegate.testPosition += 1
        self.navigationController?.pushViewController(TestOrder.sharedInstance.getTest(AppDelegate.testPosition), animated: true)
    }
    
    @IBAction func done(_ sender: AnyObject) {
        showOverlay()
        
        // Push to the API
        postToAPI()
    }
    
    @IBAction func moveToExample(_ sender: AnyObject) {
        position += 1
        
        setSubview(introView, next: example1View)
        setupSounds(examples, iterator: 0, label: example1Label)
        setupExample1()
    }
    
    @IBAction func moveToExample2(_ sender: AnyObject) {
        position += 1
        
        setSubview(example1View, next: example2View)
        setupSounds(examples, iterator: 1, label: example2Label)
        setupExample2()
        
        exampleCount += 1
    }
    
    @IBAction func moveToExample3(_ sender: AnyObject) {
        position += 1
        
        setSubview(example2View, next: example3View)
        setupSounds(examples, iterator: 2, label: example3Label)
        setupExample3()
        
        exampleCount += 1
    }
    
    
    @IBAction func moveToPractice1(_ sender: AnyObject) {
        position += 1
        
        setSubview(example3View, next: trial1View)
        setupSounds(practices, iterator: practiceCount, label: trialLabel)
        setupPractice1()
    }
    
    @IBAction func nextPractice(_ sender: AnyObject) {
        practiceCount += 1
        position += 1
        
        if practiceCount < practices.count {
            practiceResponse.text = ""
            practiceSegment.selectedSegmentIndex = -1
            practiceLabel.text = "Practice".localized(lang: language) + " " + String(practiceCount+1)
            practiceInstructionsLabel.text = "pitch_practice_2".localized(lang: language)
            
            practiceSegment.isHidden = true
            practiceBtn.isHidden = true
            
            // Set sounds to play
            setupSounds(practices, iterator: practiceCount, label: trialLabel)
        } else {
            if (soundPlayer?.isPlaying)! {
                soundPlayer?.stop()
            }
            
            setSubview(trial1View, next: preTaskView)
            
            tasksContent.text = "pitch_tasks".localized(lang: language)
            pretaskBtn.setTitle("Start".localized(lang: language), for: .normal)
        }
    }
    
    @IBAction func moveToTask(_ sender: AnyObject) {
        position += 1
        setSubview(preTaskView, next: taskView)
        setupSounds(tasks, iterator: taskCount, label: tasksLabel)
        
        tasksLabel.text = "1"
        
        taskSegment.setTitle("Same".localized(lang: language), forSegmentAt: 0)
        taskSegment.setTitle("Different".localized(lang: language), forSegmentAt: 1)
        taskBtn.setTitle("Next".localized(lang: language), for: .normal)
        
        taskSegment.isHidden = true
        taskBtn.isHidden = true
        
        play(firstSound)
        taskCount += 1
    }
    
    
    @IBAction func nextTask(_ sender: AnyObject) {
        position += 1
        if taskCount < tasks.count {
            // Set sounds to play
            setupSounds(tasks, iterator: taskCount, label: tasksLabel)
            
            // Which label back to 1
            tasksLabel.text = "1"
            taskResponse.text = ""
            taskSegment.setEnabled(true, forSegmentAt: 0)
            taskSegment.setEnabled(true, forSegmentAt: 1)
            taskSegment.selectedSegmentIndex = -1
            taskSegment.isHidden = true
            taskBtn.isHidden = true
    
            play(firstSound)
            
            taskCount += 1
        } else {
            if (soundPlayer?.isPlaying)! {
                soundPlayer?.stop()
            }
            
            setSubview(taskView, next: completeView)
            
            completeLabel.text = "Test_complete".localized(lang: language)
            submitBtn.setTitle("Submit".localized(lang: language), for: .normal)
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func replay(_ sender: AnyObject) {
        if soundPlayer != nil {
            if (soundPlayer?.isPlaying)! {
                soundPlayer?.stop()
            }
        }
        
        resetTimer()
        played = false
        self.play(firstSound)
        soundLabel.text = "1"
    }
    
    @IBAction func exampleAnswered(_ sender: AnyObject) {
        if ((sender.selectedSegmentIndex == 0 && exampleAnswers[exampleCount] == "S") || (sender.selectedSegmentIndex == 1 && exampleAnswers[exampleCount] == "D")) {
            if exampleCount == 0 {
                example1Response.text = "Correct".localized(lang: language)
            } else if exampleCount == 1 {
                example2Response.text = "Correct".localized(lang: language)
            } else if exampleCount == 2 {
                example3Response.text = "Correct".localized(lang: language)
            }
        } else {
            if exampleCount == 0 {
                example1Response.text = "Incorrect_2".localized(lang: language)
            } else if exampleCount == 1 {
                example2Response.text = "Incorrect_2".localized(lang: language)
            } else if exampleCount == 2 {
                example3Response.text = "Incorrect_2".localized(lang: language)
            }
        }
    }
    
    @IBAction func practiceAnswered(_ sender: AnyObject) {
        if ((sender.selectedSegmentIndex == 0 && practiceAnswers[practiceCount] == "S") || (sender.selectedSegmentIndex == 1 && practiceAnswers[practiceCount] == "D")) {
            practiceResponse.text = "Correct".localized(lang: language)
        } else {
            practiceResponse.text = "Incorrect_2".localized(lang: language)
        }
    }
    
    @IBAction func tasksAnswered(_ sender: AnyObject) {
        if ((sender.selectedSegmentIndex == 0 && taskAnswers[taskCount - 1] == "S") || (sender.selectedSegmentIndex == 1 && taskAnswers[taskCount - 1] == "D")) {
            taskResponse.text = "Correct".localized(lang: language)
            userAnswers.insert("c", at: taskCount - 1)
        } else {
            taskResponse.text = "Incorrect".localized(lang: language)
            userAnswers.insert("i", at: taskCount - 1)
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            taskSegment.setEnabled(false, forSegmentAt: 1)
        default:
            taskSegment.setEnabled(false, forSegmentAt: 0)
        }
        
        taskBtn.isHidden = false
    }
    
    
    
    // MARK: - Delegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        startTimer()
        
        if self.played {
            if position == 1 {
                example1btn.isHidden = false
                example1segment.isHidden = false
            } else if position == 2 {
                example2btn.isHidden = false
                example2segment.isHidden = false
            } else if position == 3 {
                example3btn.isHidden = false
                example3segment.isHidden = false
            }
            
            if position > examples.count && position <= examples.count + practices.count {
                practiceSegment.isHidden = false
                practiceBtn.isHidden = false
            } else if position > examples.count + practices.count {
                taskSegment.isHidden = false
            }
            resetTimer()
        }
    }
    
}
