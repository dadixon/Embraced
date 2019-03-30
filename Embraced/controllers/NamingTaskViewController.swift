//
//  NamingTaskViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SVProgressHUD

class NamingTaskViewController: FrontViewController {

    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timerCount: UILabel!
    @IBOutlet weak var taskImageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var initialView: UIView!
    @IBOutlet var trialView: UIView!
    @IBOutlet var preTaskView: UIView!
    @IBOutlet var taskView: UIView!
    @IBOutlet var completeView: UIView!

    @IBOutlet weak var practiceLabel: UILabel!
    @IBOutlet weak var practiceInstruction1: UILabel!
    @IBOutlet weak var pracitceInstruction2: UILabel!
    @IBOutlet weak var startBtn: NavigationButton!
    
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var exampleNextBtn: NavigationButton!
    @IBOutlet weak var exampleRecordBtn: UIButton!
    
    @IBOutlet weak var taskInstruction: UILabel!
    @IBOutlet weak var taskStartBtn: NavigationButton!
    @IBOutlet weak var taskNextBtn: NavigationButton!
    @IBOutlet weak var taskRecordBtn: UIButton!
    
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var completeSubmitBtn: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudioURL: URL!
    var audioPlayer: AVAudioPlayer!
    
    var fileName = "testNamingAudioFile.m4a"
    
    var practice = [String]()
    var tasks = [String]()
    var count = 0
    var timeCount = 5
    
    let skipBtnDelay = 5.0 * Double(NSEC_PER_SEC)
    
    var startTime = TimeInterval()
    var timer = Timer()
    var isRunning = false
    var isTask = false
    let APIUrl = "http://www.embracedapi.ugr.es/"
    let userDefaults = UserDefaults.standard
    var token: String = ""
    var id: String = ""
    var headers: HTTPHeaders = [:]
    
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
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        
        id = participant.string(forKey: "pid")!
        token = userDefaults.string(forKey: "token")!
        
        // Store user token
        StorageManager.sharedInstance.token = token
        
        StorageManager.sharedInstance.newNamingTask(id: id)
        
        self.practice = DataManager.sharedInstance.namingTaskPractice
        self.tasks = DataManager.sharedInstance.namingTaskTask
        
        initialView.translatesAutoresizingMaskIntoConstraints = false
        trialView.translatesAutoresizingMaskIntoConstraints = false
        preTaskView.translatesAutoresizingMaskIntoConstraints = false
        taskView.translatesAutoresizingMaskIntoConstraints = false
        completeView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(initialView)
        
        let leftConstraint = initialView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let topConstraint = initialView.topAnchor.constraint(equalTo: containerView.topAnchor)
        let rightConstraint = initialView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottomConstraint = initialView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
        
        practiceLabel.text = "Practice".localized(lang: language)
        practiceInstruction1.text = "naming_practice_instruction1".localized(lang: language)
        pracitceInstruction2.text = "naming_practice_instruction2".localized(lang: language)
        startBtn.setTitle("Start".localized(lang: language), for: .normal)
        recordBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        playBtn.setTitle("Play".localized(lang: language), for: .normal)
        taskRecordBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        exampleRecordBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        loadingView.stopAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.landscape)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(.all)
    }
    
    func startRecording(_ button: UIButton, fileName: String) {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
//        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
//        let pathArray = [dirPath, fileName]
//        let filePath = URL(string: pathArray.joined(separator: "/"))
//        print(filePath!.absoluteURL)
        recordedAudioURL = audioFilename
        
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(true)
        if #available(iOS 10.0, *) {
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        } else {
            // Fallback on earlier versions
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            button.setTitle("Stop_Recording".localized(lang: language), for: .normal)
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func finishRecording(_ button: UIButton, success: Bool) {
//        soundRecorder.stop()
//        soundRecorder = nil
        audioRecorder.stop()
        audioRecorder = nil
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        if success {
            button.setTitle("Start_Record".localized(lang: language), for: .normal)
        }
    }
    
//    func preparePlayer() {
//        do {
//            soundPlayer = try AVAudioPlayer(contentsOf: getDocumentsDirectory().appendingPathComponent(fileName))
//            soundPlayer?.delegate = self
//            soundPlayer?.prepareToPlay()
//            soundPlayer?.volume = 1.0
//        } catch {
//            SVProgressHUD.showError(withStatus: error.localizedDescription)
//        }
//    }
    
    @objc func updateTime() {
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        var elapsedTime : TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        if seconds >= 15 {
            timerCount.text = String(timeCount)
            
            if timeCount == 0 {
                if audioRecorder != nil {
                    audioRecorder.stop()
                    audioRecorder = nil
                    let audioSession = AVAudioSession.sharedInstance()
                    try! audioSession.setActive(false)
                }

                taskRecordBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
                
                nextTask(self)
                resetTimer()
                startTimer()
                timeCount = 5
                timerCount.text = ""
            } else {
                timeCount -= 1
            }
        }
        
    }
    
    func startTimer() {
        if !timer.isValid {
            let aSelector : Selector = #selector(updateTime)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    func resetTimer() {
        timer.invalidate()
    }
    
    // TODO: This needs to be an extension instead
    override func audioPlayerDidFinishPlaying(successfully flag: Bool) {
        if flag {
            recordBtn.isEnabled = true
            playBtn.setTitle("Play".localized(lang: language), for: .normal)
            playBtn.isEnabled = false
        } else {
            print("Player failed")
        }
    }
    
    func postToAPI(object: [String: AnyObject]) {
        do {
            try StorageManager.sharedInstance.postToNamingTask(id: id, data: object)
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        AppDelegate.position += 1
        AppDelegate.testPosition += 1
        self.navigationController?.pushViewController(TestOrder.sharedInstance.getTest(AppDelegate.testPosition), animated: true)
    }
    
    @IBAction func done(_ sender:AnyObject) {
        self.next(self)
    }
    
    // MARK: - Actions
    @IBAction func recordTapped(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording(sender, fileName: fileName)
        } else {
            finishRecording(sender, success: true)
            exampleRecordBtn.isEnabled = false
        }
    }
    
    @IBAction func recordTask(_ sender: AnyObject) {
        if audioRecorder == nil {
            startRecording(sender as! UIButton, fileName: "namingTask\(count).m4a")
        } else {
            finishRecording(sender as! UIButton, success: true)
            taskRecordBtn.isEnabled = false
            taskNextBtn.isHidden = false
        }
    }
    
    @IBAction func playSound(_ sender: UIButton) {
        if sender.titleLabel!.text == "Play".localized(lang: language) {
            recordBtn.isEnabled = false
//            sender.setTitle("Stop_Recording".localized(lang: language), for: UIControl.State())
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: recordedAudioURL)
                audioPlayer.delegate = self
                audioPlayer.play()
            } catch {
                print("No Audio")
            }
        } else {
            audioPlayer.stop()
            sender.setTitle("Play".localized(lang: language), for: .normal)
        }
    }
    
    @IBAction func initialToTrial(_ sender: AnyObject) {
        setSubview(initialView, next: trialView)
        imageView.image = UIImage(named: practice[count])
        
        exampleLabel.text = "Example".localized(lang: language)
        exampleNextBtn.setTitle("Next".localized(lang: language), for: .normal)
        exampleRecordBtn.isEnabled = true
    }
    
    @IBAction func nextExample(_ sender: AnyObject) {
        count += 1
        if count < practice.count {
            imageView.image = UIImage(named: practice[count])
            exampleRecordBtn.isEnabled = true
        } else {
            setSubview(trialView, next: preTaskView)
            
            taskInstruction.text = "naming_task_instruction".localized(lang: language)
            taskStartBtn.setTitle("Start".localized(lang: language), for: .normal)
        }
    }
    
    @IBAction func toTask(_ sender: AnyObject) {
        isTask = true
        setSubview(preTaskView, next: taskView)
        taskNextBtn.setTitle("Next".localized(lang: language), for: .normal)
        count = 0
        taskImageView.image = UIImage(named: tasks[count])
        startTimer()
        taskNextBtn.isHidden = true
    }
    
    @IBAction func nextTask(_ sender: AnyObject) {
        count += 1
        postToAPI(object: createPostObject(index: count))
        taskNextBtn.isHidden = true
        
        if count < tasks.count {
            taskRecordBtn.isEnabled = true
            taskImageView.image = UIImage(named: tasks[count])
            resetTimer()
            startTimer()
        } else {
            resetTimer()
            setSubview(taskView, next: completeView)
            completeLabel.text = "Test_complete".localized(lang: language)
            completeSubmitBtn.setTitle("Submit".localized(lang: language), for: .normal)
        }
    }
    
    func createPostObject(index: Int) -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        let name = "stimuli\(index)"
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let fileURL = documentsURL.appendingPathComponent("namingTask\(index-1).m4a")
        
        // Gather data for post
        jsonObject = [
            "index": index as AnyObject,
            "name": name as AnyObject,
            "audio": recordedAudioURL as AnyObject
        ]
        
        return jsonObject
    }
}

extension NamingTaskViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Finished recording")
            playBtn.isEnabled = true
        } else {
            print("Recording failed")
        }
    }
}

extension String {
    func stringByAppendingPathComponent(_ pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
}
