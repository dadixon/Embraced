//
//  PitchViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation

class PitchViewController: FrontViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var introView: UIView!
    @IBOutlet var example1View: UIView!
    @IBOutlet var example2View: UIView!
    @IBOutlet var example3View: UIView!
    @IBOutlet var trial1View: UIView!
    @IBOutlet var preTaskView: UIView!
    @IBOutlet var taskView: UIView!
    @IBOutlet var completeView: UIView!
    
    @IBOutlet weak var example1Label: UILabel!
    @IBOutlet weak var example2Label: UILabel!
    @IBOutlet weak var example3Label: UILabel!
    
    @IBOutlet weak var example1: UILabel!
    @IBOutlet weak var example2: UILabel!
    @IBOutlet weak var example3: UILabel!
    @IBOutlet weak var example1Content: UILabel!
    @IBOutlet weak var example2Content: UILabel!
    @IBOutlet weak var example3Content: UILabel!
    @IBOutlet weak var tasksContent: UILabel!
    @IBOutlet weak var completeLabel: UILabel!
    
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var tasksLabel: UILabel!
    @IBOutlet weak var practiceLabel: UILabel!
    @IBOutlet weak var practiceInstructionsLabel: UILabel!
    
    @IBOutlet weak var example1Response: UILabel!
    @IBOutlet weak var example2Response: UILabel!
    @IBOutlet weak var example3Response: UILabel!
    @IBOutlet weak var practiceResponse: UILabel!
    @IBOutlet weak var taskResponse: UILabel!
    
    @IBOutlet weak var example1segment: UISegmentedControl!
    @IBOutlet weak var example2segment: UISegmentedControl!
    @IBOutlet weak var example3segment: UISegmentedControl!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var practiceSegment: UISegmentedControl!
    @IBOutlet weak var taskSegment: UISegmentedControl!
    
    @IBOutlet weak var introBtn: NavigationButton!
    @IBOutlet weak var example1btn: NavigationButton!
    @IBOutlet weak var example2btn: NavigationButton!
    @IBOutlet weak var example3btn: NavigationButton!
    @IBOutlet weak var practiceBtn: NavigationButton!
    @IBOutlet weak var pretaskBtn: NavigationButton!
    @IBOutlet weak var taskBtn: NavigationButton!
    @IBOutlet weak var submitBtn: UIButton!

    var stimuli = [String: Any]()
    var examples = Array<Array<String>>()
    var trials = Array<Array<String>>()
    var tasks = Array<Array<String>>()
    
    let exampleAnswers = ["S", "D", "D"]
    let practiceAnswers = ["D", "D", "S", "D", "D"]
    let taskAnswers = ["S", "D", "S", "D", "D", "S", "D", "S", "D", "D", "S", "S", "S", "S", "D", "D", "D", "D", "D", "S", "S", "S", "S", "D"]
    
    var userAnswers = [String]()
    var score = Int()
    
    var firstSound = String()
    var secondSound = String()
    var soundLabel = UILabel()
    var played = false
    
    var exampleCount = 0
    var trialCount = 0
    var tasksCount = 0
    
    var timer = Timer()
    
    
    // MARK: - Private
    
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
        step = 7
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(PitchViewController.next(_:)))
        
        orientation = "portrait"
        rotated()
        
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
        examples = DataManager.sharedInstance.pitchExamples
        trials = DataManager.sharedInstance.pitchTrials
        tasks = DataManager.sharedInstance.pitchTasks
        
        let pathResource = Bundle.main.path(forResource: "melodies 320ms orig(16)", ofType: "wav")
        let finishedStepSound = NSURL(fileURLWithPath: pathResource!)
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: finishedStepSound as URL)
            if(soundPlayer.prepareToPlay()){
                print("preparation success")
                soundPlayer.delegate = self
            }else{
                print("preparation failure")
            }
            
        }catch{
            print("Sound file could not be found")
        }
        
        introBtn.setTitle("Start".localized(lang: participant.string(forKey: "language")!), for: .normal)
        introLabel.text = "pitch_intro".localized(lang: participant.string(forKey: "language")!)
        
        loadingView.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupSounds(_ soundArray: Array<Array<String>>, iterator: Int, label: UILabel) {
        if soundPlayer.isPlaying {
            soundPlayer.stop()
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
        
        print(firstSound)
        print(secondSound)
        
        let firstSoundArray = firstSound.characters.split(separator: ".").map(String.init)
        let secondSoundArray = secondSound.characters.split(separator: ".").map(String.init)
        
        firstSound = firstSoundArray[0]
        secondSound = secondSoundArray[0]
        
        print(firstSound)
        print(secondSound)
        
        soundLabel = label
        soundLabel.text = "1"
    }
    
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        let vc:DigitalSpanViewController = DigitalSpanViewController()
        nextViewController(viewController: vc)
    }
    
    @IBAction func done(_ sender: AnyObject) {
        print(userAnswers)
        var jsonObject = [String: AnyObject]()
        
        // Gather data for post
        jsonObject = [
            "answers": userAnswers as AnyObject,
            "score": score as AnyObject
        ]
        
        APIWrapper.post(id: participant.string(forKey: "pid")!, test: "pitch", data: jsonObject)
        
        next(self)
    }
    
    @IBAction func moveToExample(_ sender: AnyObject) {
        setSubview(introView, next: example1View)
        setupSounds(examples, iterator: 0, label: example1Label)
        
        example1.text = "Example_1".localized(lang: participant.string(forKey: "language")!)
        example1Content.text = "pitch_example_1".localized(lang: participant.string(forKey: "language")!)
        example1btn.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
        example1segment.setTitle("Same".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 0)
        example1segment.setTitle("Different".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 1)
    }
    
    @IBAction func moveToExample2(_ sender: AnyObject) {
        setSubview(example1View, next: example2View)
        setupSounds(examples, iterator: 1, label: example2Label)
        
        example2.text = "Example_2".localized(lang: participant.string(forKey: "language")!)
        example2Content.text = "pitch_example_2".localized(lang: participant.string(forKey: "language")!)
        example2btn.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
        example2segment.setTitle("Same".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 0)
        example2segment.setTitle("Different".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 1)
        
        exampleCount += 1
    }
    
    @IBAction func moveToExample3(_ sender: AnyObject) {
        setSubview(example2View, next: example3View)
        setupSounds(examples, iterator: 2, label: example3Label)
        
        example3.text = "Example_3".localized(lang: participant.string(forKey: "language")!)
        example3Content.text = "pitch_example_3".localized(lang: participant.string(forKey: "language")!)
        example3btn.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
        example3segment.setTitle("Same".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 0)
        example3segment.setTitle("Different".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 1)
        
        exampleCount += 1
    }
    
    
    @IBAction func moveToTrial1(_ sender: AnyObject) {
        setSubview(example3View, next: trial1View)
        setupSounds(trials, iterator: trialCount, label: trialLabel)
        
        practiceLabel.text = "Practice".localized(lang: participant.string(forKey: "language")!) + " " + String(trialCount+1)
        practiceInstructionsLabel.text = "pitch_practice_1".localized(lang: participant.string(forKey: "language")!)
        practiceSegment.setTitle("Same".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 0)
        practiceSegment.setTitle("Different".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 1)
        practiceBtn.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
    }
    
    @IBAction func nextTrial(_ sender: AnyObject) {
        trialCount += 1
        
        if trialCount < trials.count {
            // Which label back to 1
            trialLabel.text = "1"
            practiceResponse.text = ""
            practiceSegment.selectedSegmentIndex = -1
            practiceLabel.text = "Practice".localized(lang: participant.string(forKey: "language")!) + " " + String(trialCount+1)
            practiceInstructionsLabel.text = "pitch_practice_2".localized(lang: participant.string(forKey: "language")!)
            
            // Set sounds to play
            setupSounds(trials, iterator: trialCount, label: trialLabel)
        } else {
            if soundPlayer.isPlaying {
                soundPlayer.stop()
            }
            
            setSubview(trial1View, next: preTaskView)
            
            tasksContent.text = "pitch_tasks".localized(lang: participant.string(forKey: "language")!)
            pretaskBtn.setTitle("Start".localized(lang: participant.string(forKey: "language")!), for: .normal)
        }
    }
    
    @IBAction func moveToTask(_ sender: AnyObject) {
        setSubview(preTaskView, next: taskView)
        setupSounds(tasks, iterator: tasksCount, label: tasksLabel)
        
        taskSegment.setTitle("Same".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 0)
        taskSegment.setTitle("Different".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 1)
        taskBtn.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
        
        play(firstSound)
        tasksCount += 1
    }
    
    
    @IBAction func nextTask(_ sender: AnyObject) {
        if tasksCount < tasks.count {
            // Save answer
            
            // Which label back to 1
            tasksLabel.text = "1"
            taskResponse.text = ""
            taskSegment.setEnabled(true, forSegmentAt: 0)
            taskSegment.setEnabled(true, forSegmentAt: 1)
            taskSegment.selectedSegmentIndex = -1
            
            // Set sounds to play
            setupSounds(tasks, iterator: tasksCount, label: tasksLabel)
            
            play(firstSound)
            
            tasksCount += 1
        } else {
            if soundPlayer.isPlaying {
                soundPlayer.stop()
            }
            
            setSubview(taskView, next: completeView)
            
            completeLabel.text = "Test_complete".localized(lang: participant.string(forKey: "language")!)
            submitBtn.setTitle("Submit".localized(lang: participant.string(forKey: "language")!), for: .normal)
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func replay(_ sender: AnyObject) {
        if soundPlayer.isPlaying {
            soundPlayer.stop()
        }
        
        resetTimer()
        played = false
        self.play(firstSound)
        soundLabel.text = "1"
    }
    
    @IBAction func exampleAnswered(_ sender: AnyObject) {
        if ((sender.selectedSegmentIndex == 0 && exampleAnswers[exampleCount] == "S") || (sender.selectedSegmentIndex == 1 && exampleAnswers[exampleCount] == "D")) {
            if exampleCount == 0 {
                example1Response.text = "Correct".localized(lang: participant.string(forKey: "language")!)
            } else if exampleCount == 1 {
                example2Response.text = "Correct".localized(lang: participant.string(forKey: "language")!)
            } else if exampleCount == 2 {
                example3Response.text = "Correct".localized(lang: participant.string(forKey: "language")!)
            }
        } else {
            if exampleCount == 0 {
                example1Response.text = "Incorrect_2".localized(lang: participant.string(forKey: "language")!)
            } else if exampleCount == 1 {
                example2Response.text = "Incorrect_2".localized(lang: participant.string(forKey: "language")!)
            } else if exampleCount == 2 {
                example3Response.text = "Incorrect_2".localized(lang: participant.string(forKey: "language")!)
            }
        }
    }
    
    @IBAction func practiceAnswered(_ sender: AnyObject) {
        if ((sender.selectedSegmentIndex == 0 && practiceAnswers[trialCount] == "S") || (sender.selectedSegmentIndex == 1 && practiceAnswers[trialCount] == "D")) {
            practiceResponse.text = "Correct".localized(lang: participant.string(forKey: "language")!)
        } else {
            practiceResponse.text = "Incorrect_2".localized(lang: participant.string(forKey: "language")!)
        }
    }
    
    @IBAction func taskAnswered(_ sender: AnyObject) {
        if ((sender.selectedSegmentIndex == 0 && taskAnswers[tasksCount - 1] == "S") || (sender.selectedSegmentIndex == 1 && taskAnswers[tasksCount - 1] == "D")) {
            taskResponse.text = "Correct".localized(lang: participant.string(forKey: "language")!)
            userAnswers.insert("c", at: tasksCount - 1)
            score += 1
        } else {
            taskResponse.text = "Incorrect".localized(lang: participant.string(forKey: "language")!)
            userAnswers.insert("i", at: tasksCount - 1)
            score -= 1
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            taskSegment.setEnabled(false, forSegmentAt: 1)
        default:
            taskSegment.setEnabled(false, forSegmentAt: 0)
        }
    }
    
    
    func updateTime() {
        if self.played == false {
            self.soundLabel.text = "2"
            play(secondSound)
        }
        
        self.played = true
    }
    
    func startTimer() {
        if !timer.isValid {
            
            let aSelector : Selector = #selector(NamingTaskViewController.updateTime)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
        }
    }
    
    func resetTimer() {
        timer.invalidate()
    }
    
    
    // MARK: - Delegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished")
        startTimer()
    }
    
}
