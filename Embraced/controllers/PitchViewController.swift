//
//  PitchViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation

class PitchViewController: FrontViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var introView: UIView!
    @IBOutlet var example1View: UIView!
    @IBOutlet var example2View: UIView!
    @IBOutlet var example3View: UIView!
    @IBOutlet var trial1View: UIView!
    @IBOutlet var preTaskView: UIView!
    @IBOutlet var taskView: UIView!
    
    @IBOutlet weak var example1Label: UILabel!
    @IBOutlet weak var example2Label: UILabel!
    @IBOutlet weak var example3Label: UILabel!
    
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var tasksLabel: UILabel!
    
    @IBOutlet weak var example1Response: UILabel!
    @IBOutlet weak var example2Response: UILabel!
    @IBOutlet weak var example3Response: UILabel!
    @IBOutlet weak var practiceResponse: UILabel!
    @IBOutlet weak var taskResponse: UILabel!
    
    @IBOutlet weak var practiceSegment: UISegmentedControl!
    @IBOutlet weak var taskSegment: UISegmentedControl!
    
    var soundPlayer: AVAudioPlayer!
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
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(PitchViewController.back(_:)))
        
        orientation = "portrait"
        rotated()
        
        introView.translatesAutoresizingMaskIntoConstraints = false
        example1View.translatesAutoresizingMaskIntoConstraints = false
        example2View.translatesAutoresizingMaskIntoConstraints = false
        example3View.translatesAutoresizingMaskIntoConstraints = false
        trial1View.translatesAutoresizingMaskIntoConstraints = false
        preTaskView.translatesAutoresizingMaskIntoConstraints = false
        taskView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(introView)
        
        let leftConstraint = introView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let topConstraint = introView.topAnchor.constraint(equalTo: containerView.topAnchor)
        let rightConstraint = introView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottomConstraint = introView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
        
        
        // Fetch audios
//        examples = appDelegate.pitchStimuli["examples"] as! Array<Array<String>>
        examples = appDelegate.pitchExamples
        trials = appDelegate.pitchStimuli["trials"] as! Array<Array<String>>
        tasks = appDelegate.pitchStimuli["tasks"] as! Array<Array<String>>
        
        loadingView.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func play(_ filename:String) {
        do {
//            let filename = "melodies-320ms-orig(16).wav"
//            let path = Bundle.main.path(forResource: "melodies-320ms-orig(16).wav", ofType: nil)
//            let url = URL(fileURLWithPath: path!)
            soundPlayer = try AVAudioPlayer(contentsOf: getDocumentsDirectory().appendingPathComponent(filename))
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
            soundPlayer.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
//    func downloadFileFromURL(url:NSURL){
//        var downloadTask:URLSessionDownloadTask
//        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { (URL, response, error) -> Void in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//            print(URL! as NSURL)
//            self.play(URL! as NSURL)
//        })
//        
//        downloadTask.resume()
//    }
    
    private func setupSounds(_ soundArray: Array<Array<String>>, iterator: Int, label: UILabel) {
        if soundPlayer != nil {
            soundPlayer.stop()
        }
        
        played = false
        
        if soundArray[iterator].count > 1 {
            firstSound = soundArray[iterator][1]
            secondSound = soundArray[iterator][0]
        } else if soundArray[iterator].count == 1 {
            firstSound = soundArray[iterator][0]
            secondSound = soundArray[iterator][0]
        }
        
        print(firstSound)
        print(secondSound)
        
//        let url = NSURL(string: firstSound)
        self.play(firstSound)
//        downloadFileFromURL(url: url!)
        soundLabel = label
        soundLabel.text = "1"
    }
    
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        let mOCAMMSETestViewController:DigitalSpanViewController = DigitalSpanViewController()
        self.navigationController?.pushViewController(mOCAMMSETestViewController, animated: true)
    }
    
    
    // MARK: - Actions
    
    @IBAction func moveToExample(_ sender: AnyObject) {
        setSubview(introView, next: example1View)
        setupSounds(examples, iterator: 0, label: example1Label)
    }
    
    @IBAction func moveToExample2(_ sender: AnyObject) {
        setSubview(example1View, next: example2View)
        setupSounds(examples, iterator: 1, label: example2Label)
        exampleCount += 1
    }
    
    @IBAction func replay(_ sender: AnyObject) {
        if soundPlayer != nil {
            soundPlayer.stop()
        }
        
        played = false
        play(firstSound)
//        let url = NSURL(string: firstSound)
//        downloadFileFromURL(url: url!)
        soundLabel.text = "1"
    }
    
    @IBAction func moveToExample3(_ sender: AnyObject) {
        soundPlayer.stop()
        setSubview(example2View, next: example3View)
        setupSounds(examples, iterator: 2, label: example3Label)
        exampleCount += 1
    }
    
    
    @IBAction func moveToTrial1(_ sender: AnyObject) {
        soundPlayer.stop()
        setSubview(example3View, next: trial1View)
        setupSounds(trials, iterator: trialCount, label: trialLabel)
    }
    
    @IBAction func exampleAnswered(_ sender: AnyObject) {
        if ((sender.selectedSegmentIndex == 0 && exampleAnswers[exampleCount] == "S") || (sender.selectedSegmentIndex == 1 && exampleAnswers[exampleCount] == "D")) {
            if exampleCount == 0 {
                example1Response.text = "Correct!"
            } else if exampleCount == 1 {
                example2Response.text = "Correct!"
            } else if exampleCount == 2 {
                example3Response.text = "Correct!"
            }
        } else {
            if exampleCount == 0 {
                example1Response.text = "Sorry, that was an incorrect response. You can try again."
            } else if exampleCount == 1 {
                example2Response.text = "Sorry, that was an incorrect response. You can try again."
            } else if exampleCount == 2 {
                example3Response.text = "Sorry, that was an incorrect response. You can try again."
            }
        }
    }
    
    @IBAction func practiceAnswered(_ sender: AnyObject) {
        if ((sender.selectedSegmentIndex == 0 && practiceAnswers[trialCount] == "S") || (sender.selectedSegmentIndex == 1 && practiceAnswers[trialCount] == "D")) {
            practiceResponse.text = "Correct!"
        } else {
            practiceResponse.text = "Sorry, that was an incorrect response. You can try again."
        }
    }
    
    @IBAction func taskAnswered(_ sender: AnyObject) {
        if ((sender.selectedSegmentIndex == 0 && taskAnswers[tasksCount - 1] == "S") || (sender.selectedSegmentIndex == 1 && taskAnswers[tasksCount - 1] == "D")) {
            taskResponse.text = "Correct!"
            userAnswers.insert("c", at: tasksCount - 1)
            score += 1
        } else {
            taskResponse.text = "Incorrect"
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
    
    @IBAction func nextTrial(_ sender: AnyObject) {
        trialCount += 1
        
        if trialCount < trials.count {
            // Save answer
            
            // Which label back to 1
            trialLabel.text = "1"
            practiceResponse.text = ""
            practiceSegment.selectedSegmentIndex = -1
            
            // Set sounds to play
            setupSounds(trials, iterator: trialCount, label: trialLabel)
        } else {
            //            if soundPlayer != nil {
            soundPlayer.stop()
            //            }
            
            setSubview(trial1View, next: preTaskView)
        }
    }
    
    @IBAction func moveToTask(_ sender: AnyObject) {
        setSubview(preTaskView, next: taskView)
        setupSounds(tasks, iterator: tasksCount, label: tasksLabel)
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
            
            tasksCount += 1
        } else {
            soundPlayer.stop()
            print(userAnswers)
            var jsonObject = [String: AnyObject]()
            
            // Gather data for post
            jsonObject = [
                "answers": userAnswers as AnyObject,
                "score": score as AnyObject
            ]
            
            APIWrapper.post(id: participant.string(forKey: "pid")!, test: "pitch", data: jsonObject)
            
            let mOCAMMSETestViewController:DigitalSpanViewController = DigitalSpanViewController()
            self.navigationController?.pushViewController(mOCAMMSETestViewController, animated: true)
        }
    }
    
    
    func updateTime() {
        if self.played == false {
            self.soundLabel.text = "2"
//            let url = NSURL(string: self.secondSound)
//            self.downloadFileFromURL(url: url!)
            play(secondSound)
        }
        
        self.played = true
        
//        let currentTime = Date.timeIntervalSinceReferenceDate
//        
//        var elapsedTime : TimeInterval = currentTime - startTime
//        
//        //calculate the minutes in elapsed time
//        
//        let minutes = UInt8(elapsedTime / 60.0)
//        elapsedTime -= (TimeInterval(minutes) * 60)
//        
//        //calculate the seconds in elapsed time
//        
//        let seconds = UInt8(elapsedTime)
//        elapsedTime -= TimeInterval(seconds)
//        
//        if seconds >= 15 {
//            timerCount.text = String(timeCount)
//            
//            if timeCount == 0 {
//                nextTask(self)
//                resetTimer()
//                startTimer()
//                timeCount = 5
//                timerCount.text = ""
//            } else {
//                timeCount -= 1
//            }
//        }
        
    }
    
    func startTimer() {
        if !timer.isValid {
            
            let aSelector : Selector = #selector(NamingTaskViewController.updateTime)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
            
//            startTime = Date.timeIntervalSinceReferenceDate
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
