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
    

    let downloadManager = DownloadManager()
    
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
    var position = 0
    
    var timer = Timer()
    
    
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
        
        introBtn.isEnabled = false
        
        // Fetch audios
        // New way by downloading files instead of using native ones
        
        let todoEndpoint: String = "http://api.girlscouts.harryatwal.com/stimuli/pitch"
        
        guard let url = URL(string: todoEndpoint) else {
//            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            guard error == nil else {
//                print("error calling GET on stumiliNames")
//                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
//                print("Error: did not receive data")
                return
            }
            
            if (statusCode == 200) {
//                print("Everyone is fine, file downloaded successfully.")
                
                do {
                    guard let todo = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] else {
//                        print("error trying to convert data to JSON")
                        return
                    }
                    
//                    stimuliURIs = todo
//                    print(todo["examples"]!)
                    self.examples = todo["examples"]! as! Array<Array<String>>
                    self.trials = todo["trials"]! as! Array<Array<String>>
                    self.tasks = todo["tasks"]! as! Array<Array<String>>
                    
                    self.introBtn.isEnabled = true
                } catch {
//                    print("Error with Json: \(error)")
                    return
                }
            }
        })
        
        task.resume()
    
    
    
    
        
//        examples = DataManager.sharedInstance.pitchExamples
//        trials = DataManager.sharedInstance.pitchTrials
//        tasks = DataManager.sharedInstance.pitchTasks
        
        introBtn.setTitle("Start".localized(lang: participant.string(forKey: "language")!), for: .normal)
        introLabel.text = "pitch_intro".localized(lang: participant.string(forKey: "language")!)
        
        for index in 0...24 {
            userAnswers.insert("", at: index)
        }
            
        loadingView.stopAnimating()
//        log(logMessage: "finished")
    }
    
    override func didReceiveMemoryWarning() {
//        log(logMessage: "initi")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime() {
//        log(logMessage: "initi")
        if self.played == false {
            self.soundLabel.text = "2"
            play(secondSound)
            
            resetTimer()
        }
        
        self.played = true
//        log(logMessage: "finished")
    }
    
    private func startTimer() {
//        log(logMessage: "initi")
        if !timer.isValid {
            let aSelector : Selector = #selector(PitchViewController.updateTime)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
        }
//        log(logMessage: "finished")/
    }
    
    private func resetTimer() {
//        log(logMessage: "initi")
        timer.invalidate()
//        log(logMessage: "finished")
    }
    
    private func setupSounds(_ soundArray: Array<Array<String>>, iterator: Int, label: UILabel) {
//        log(logMessage: "initi")
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
        
//        print(firstSound)
//        print(secondSound)
        
        soundLabel = label
        soundLabel.text = ""
//        log(logMessage: "finished")
    }
    
    func setupExample1() {
//        log(logMessage: "initi")
        example1.text = "Example".localized(lang: participant.string(forKey: "language")!) + " 1"
        example1Content.text = "pitch_example_1".localized(lang: participant.string(forKey: "language")!)
        example1btn.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
        example1segment.setTitle("Same".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 0)
        example1segment.setTitle("Different".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 1)
        
        example1btn.isHidden = true
        example1segment.isHidden = true
//        log(logMessage: "finished")
    }
    
    func setupExample2() {
//        log(logMessage: "initi")
        example2.text = "Example".localized(lang: participant.string(forKey: "language")!) + " 2"
        example2Content.text = "pitch_example_2".localized(lang: participant.string(forKey: "language")!)
        example2btn.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
        example2segment.setTitle("Same".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 0)
        example2segment.setTitle("Different".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 1)
        
        example2btn.isHidden = true
        example2segment.isHidden = true
//        log(logMessage: "finished")
    }
    
    func setupExample3() {
//        log(logMessage: "initi")
        example3.text = "Example".localized(lang: participant.string(forKey: "language")!) + " 3"
        example3Content.text = "pitch_example_3".localized(lang: participant.string(forKey: "language")!)
        example3btn.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
        example3segment.setTitle("Same".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 0)
        example3segment.setTitle("Different".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 1)
        
        example3btn.isHidden = true
        example3segment.isHidden = true
//        log(logMessage: "finished")
    }
    
    func setupTrial1() {
//        log(logMessage: "initi")
        practiceLabel.text = "Practice".localized(lang: participant.string(forKey: "language")!) + " " + String(trialCount+1)
        practiceInstructionsLabel.text = "pitch_practice_1".localized(lang: participant.string(forKey: "language")!)
        practiceSegment.setTitle("Same".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 0)
        practiceSegment.setTitle("Different".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 1)
        practiceBtn.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
        
        practiceSegment.isHidden = true
        practiceBtn.isHidden = true
//        log(logMessage: "finished")
    }

    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
//        log(logMessage: "initi")
        AppDelegate.position += 1
        nextViewController2(position: AppDelegate.position)
//        log(logMessage: "finished")
    }
    
    @IBAction func done(_ sender: AnyObject) {
//        log(logMessage: "initi")
//        print(userAnswers)
        var jsonObject = [String: AnyObject]()
        
        // Gather data for post
        jsonObject = [
            "answers": userAnswers as AnyObject,
            "score": score as AnyObject
        ]
        
        APIWrapper.post(id: participant.string(forKey: "pid")!, test: "pitch", data: jsonObject)
//        APIWrapper.post(id: "abc123", test: "pitch", data: jsonObject)
        
        next(self)
//        log(logMessage: "finished")
    }
    
    @IBAction func moveToExample(_ sender: AnyObject) {
//        log(logMessage: "initi")
        position += 1
        
        setSubview(introView, next: example1View)
        setupSounds(examples, iterator: 0, label: example1Label)
        setupExample1()
//        log(logMessage: "finished")
    }
    
    @IBAction func moveToExample2(_ sender: AnyObject) {
//        log(logMessage: "initi")
        position += 1
        
        setSubview(example1View, next: example2View)
        setupSounds(examples, iterator: 1, label: example2Label)
        setupExample2()
        
        exampleCount += 1
//        log(logMessage: "finished")
    }
    
    @IBAction func moveToExample3(_ sender: AnyObject) {
//        log(logMessage: "initi")
        position += 1
        
        setSubview(example2View, next: example3View)
        setupSounds(examples, iterator: 2, label: example3Label)
        setupExample3()
        
        exampleCount += 1
//        log(logMessage: "finished")
    }
    
    
    @IBAction func moveToTrial1(_ sender: AnyObject) {
//        log(logMessage: "initi")
        position += 1
        
        setSubview(example3View, next: trial1View)
        setupSounds(trials, iterator: trialCount, label: trialLabel)
        setupTrial1()
//        log(logMessage: "finished")
    }
    
    @IBAction func nextTrial(_ sender: AnyObject) {
//        log(logMessage: "initi")
        trialCount += 1
        position += 1
        
        if trialCount < trials.count {
            practiceResponse.text = ""
            practiceSegment.selectedSegmentIndex = -1
            practiceLabel.text = "Practice".localized(lang: participant.string(forKey: "language")!) + " " + String(trialCount+1)
            practiceInstructionsLabel.text = "pitch_practice_2".localized(lang: participant.string(forKey: "language")!)
            
            practiceSegment.isHidden = true
            practiceBtn.isHidden = true
            
            // Set sounds to play
            setupSounds(trials, iterator: trialCount, label: trialLabel)
        } else {
            if (soundPlayer?.isPlaying)! {
                soundPlayer?.stop()
            }
            
            setSubview(trial1View, next: preTaskView)
            
            tasksContent.text = "pitch_tasks".localized(lang: participant.string(forKey: "language")!)
            pretaskBtn.setTitle("Start".localized(lang: participant.string(forKey: "language")!), for: .normal)
        }
//        log(logMessage: "finished")
    }
    
    @IBAction func moveToTask(_ sender: AnyObject) {
//        log(logMessage: "initi")
        setSubview(preTaskView, next: taskView)
        setupSounds(tasks, iterator: tasksCount, label: tasksLabel)
        
        tasksLabel.text = "1"
        
        taskSegment.setTitle("Same".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 0)
        taskSegment.setTitle("Different".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 1)
        taskBtn.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
        
        taskSegment.isHidden = true
        taskBtn.isHidden = true
        
        play(firstSound)
        tasksCount += 1
//        log(logMessage: "finished")
    }
    
    
    @IBAction func nextTask(_ sender: AnyObject) {
//        log(logMessage: "initi")
        if tasksCount < tasks.count {
            // Set sounds to play
            setupSounds(tasks, iterator: tasksCount, label: tasksLabel)
            
            // Which label back to 1
            tasksLabel.text = "1"
            taskResponse.text = ""
            taskSegment.setEnabled(true, forSegmentAt: 0)
            taskSegment.setEnabled(true, forSegmentAt: 1)
            taskSegment.selectedSegmentIndex = -1
            taskSegment.isHidden = true
            taskBtn.isHidden = true
            
            
            
            play(firstSound)
            
            tasksCount += 1
        } else {
            if (soundPlayer?.isPlaying)! {
                soundPlayer?.stop()
            }
            
            setSubview(taskView, next: completeView)
            
            completeLabel.text = "Test_complete".localized(lang: participant.string(forKey: "language")!)
            submitBtn.setTitle("Submit".localized(lang: participant.string(forKey: "language")!), for: .normal)
        }
//        log(logMessage: "finished")
    }
    
    
    // MARK: - Actions
    
    @IBAction func replay(_ sender: AnyObject) {
//        log(logMessage: "initi")
        if soundPlayer != nil {
            if (soundPlayer?.isPlaying)! {
                soundPlayer?.stop()
            }
        }
        
        resetTimer()
        played = false
        self.play(firstSound)
        soundLabel.text = "1"
//        log(logMessage: "finished")
    }
    
    @IBAction func exampleAnswered(_ sender: AnyObject) {
//        log(logMessage: "initi")
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
//        log(logMessage: "finished")
    }
    
    @IBAction func practiceAnswered(_ sender: AnyObject) {
//        log(logMessage: "initi")
        if ((sender.selectedSegmentIndex == 0 && practiceAnswers[trialCount] == "S") || (sender.selectedSegmentIndex == 1 && practiceAnswers[trialCount] == "D")) {
            practiceResponse.text = "Correct".localized(lang: participant.string(forKey: "language")!)
        } else {
            practiceResponse.text = "Incorrect_2".localized(lang: participant.string(forKey: "language")!)
        }
//        log(logMessage: "finished")
    }
    
    @IBAction func taskAnswered(_ sender: AnyObject) {
//        log(logMessage: "initi")
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
//        log(logMessage: "finished")
    }
    
    
    
    // MARK: - Delegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        log(logMessage: "initi")
//        print("finished")
        startTimer()
        
        if self.played {
            if position == 1 {
//                print("show example 1")
                example1btn.isHidden = false
                example1segment.isHidden = false
            } else if position == 2 {
//                print("show example 2")
                example2btn.isHidden = false
                example2segment.isHidden = false
            } else if position == 3 {
//                print("show example 3")
                example3btn.isHidden = false
                example3segment.isHidden = false
            }
            
            if position > examples.count && position <= examples.count + trials.count {
                practiceSegment.isHidden = false
                practiceBtn.isHidden = false
            } else if position > examples.count + trials.count {
                taskSegment.isHidden = false
                taskBtn.isHidden = false
            }
            resetTimer()
        }
//        log(logMessage: "finished")
    }
    
}
