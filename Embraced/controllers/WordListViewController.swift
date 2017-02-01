//
//  WordListViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class WordListViewController: FrontViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet var practiceView: UIView!
    @IBOutlet var trial1View: UIView!
    @IBOutlet var completeView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var trialRecordBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var InstructionsLabel: UILabel!
    @IBOutlet weak var instructions2Label: UILabel!
    @IBOutlet weak var listenBtn: UIButton!
    
    
    var recordingSession: AVAudioSession!
    
    var soundRecorder: AVAudioRecorder!
    var fileName : [String] = ["testAudioFile.m4a", "trial1.m4a", "trial2.m4a", "trial3.m4a", "trial4.m4a", "trial5.m4a"]
    
    var startTime = TimeInterval()
    var timer = Timer()
    var count = 3
    var trials = Array<String>()
    var sound = String()
    var practice = true
    var position = 0
    var instructions : [String] = ["There will be a 3 second countdown before the list starts. \nPlease tap the LISTEN button when you are ready to start",
                                   "Tap the LISTEN button to listen to the list again",
                                   "Tap the LISTEN button to listen to the list again",
                                   "Tap the LISTEN button to listen to the list again",
                                   "This is the last time that you are going to listen to this list. Tap the screen to listen to the list again",
                                   "Now you are going to listen to a different list of words. Again, once the list is finished say out loud all the words you can remember from this second list.\nTap the screen to listen to this new list"]
    var instructions2 : [String] = ["Now say out loud all the words you can remember from the list. Tap the microphone button to start recording",
                                    "Now say out loud all the words you can remember from the list, including the ones you said before.\nTap the microphone button to start recording.",
                                   "Now say out loud all the words you can remember from the list, including the ones you said before.\nTap the microphone button to start recording.",
                                   "Now say out loud all the words you can remember from the list, including the ones you said before. \nTap the microphone button to start recording",
                                   "Now say out loud all the words you can remember from the list, including the ones you said before. \nTap the microphone button to start recording",
                                   "Now say out loud all the words you can remember from the list. \nTap the microphone button to start recording"]
    
    
    
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
        step = AppDelegate.position
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(WordListViewController.next(_:)))
        
        orientation = "landscape"
        rotated()
        
        practiceView.translatesAutoresizingMaskIntoConstraints = false
        trial1View.translatesAutoresizingMaskIntoConstraints = false
        completeView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(practiceView)
        
        let leftConstraint = practiceView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let topConstraint = practiceView.topAnchor.constraint(equalTo: containerView.topAnchor)
        let rightConstraint = practiceView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottomConstraint = practiceView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordBtn.isEnabled = true
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
        // Fetch audios
        trials = DataManager.sharedInstance.wordListTrials
        
        loadingView.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        instructions2Label.isHidden = true
        
        if position < 5 {
            titleLabel.text = "Trial \(position + 1)"
        } else {
            titleLabel.text = "" //"Interference list"
        }
        
        InstructionsLabel.text = instructions[position]
        instructions2Label.text = instructions2[position]
        trialRecordBtn.isEnabled = false
        listenBtn.isEnabled = true
    }
    
    
    func startRecording(_ button: UIButton, fileName: String) {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            soundRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            soundRecorder.delegate = self
            soundRecorder.record()
            
            button.setTitle("Stop", for: .normal)
        } catch {
            finishRecording(button: button, success: false)
        }
    }
    
    
    func finishRecording(button: UIButton, success: Bool) {
        soundRecorder.stop()
        soundRecorder = nil
        
        if success {
            button.setTitle("Re-record", for: .normal)
        } else {
            button.setTitle("Record", for: .normal)
            // recording failed :(
        }
    }
    
    func finishPlaying() {
        if (soundPlayer?.isPlaying)! {
            soundPlayer?.stop()
        }
        
        if practice {
            playBtn.setTitle("Play", for: .normal)
            recordBtn.isEnabled = true
        } else {
            instructions2Label.isHidden = false
            trialRecordBtn.isEnabled = true
            listenBtn.isEnabled = false
        }
    }
    
    func preparePlayer() {
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: getDocumentsDirectory().appendingPathComponent(fileName[0]))
            soundPlayer?.delegate = self
            soundPlayer?.prepareToPlay()
            soundPlayer?.volume = 1.0
        } catch {
            log(logMessage: "Something went wrong")
        }
    }
    
    
    
    func log(logMessage: String, functionName: String = #function) {
        print("\(functionName): \(logMessage)")
    }
    
    func startTimer() {
        if !timer.isValid {
            
            let aSelector : Selector = #selector(UIMenuController.update)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
            
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    func update() {
        if(count > 0) {
            countLabel.text = String(count)
            count -= 1
        } else {
            resetTimer()
            countLabel.text = ""
            
            if position < 5 {
                self.play(trials[0])
            } else {
                self.play(trials[1])
            }
        }
    }
    
    func resetTimer() {
        timer.invalidate()
    }
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
//        let vc:StroopViewController = StroopViewController()
//        nextViewController(viewController: vc)
        AppDelegate.position += 1
        nextViewController2(position: AppDelegate.position)
    }

    @IBAction func done(_ sender: AnyObject) {
        APIWrapper.post(id: participant.string(forKey: "pid")!, test: "wordlist", data: createPostObject())
        next(self)
    }
    
    @IBAction func moveToTrial1(_ sender: AnyObject) {
        setSubview(practiceView, next: trial1View)
        setup()
        practice = false
    }
    
    
    // MARK: - Action
    
    @IBAction func recordTapped(_ sender: UIButton) {
        if soundRecorder == nil {
            startRecording(sender, fileName: "wordlist\(position).m4a")
        } else {
            finishRecording(button: sender, success: true)
        }
    }
    
    @IBAction func playSound(_ sender: UIButton) {
        if sender.titleLabel!.text == "Play" {
            recordBtn.isEnabled = false
            sender.setTitle("Stop", for: UIControlState())
            preparePlayer()
            soundPlayer?.play()
        } else {
            if (soundPlayer?.isPlaying)! {
                soundPlayer?.stop()
            }
            sender.setTitle("Play", for: UIControlState())
        }
    }
    
    @IBAction func listen(_ sender: AnyObject) {
        count = 3
        startTimer()
        listenBtn.isEnabled = false
    }
    
    @IBAction func nextTrial(_ sender: AnyObject) {
        position += 1
        
        if (soundPlayer?.isPlaying)! {
            soundPlayer?.stop()
        }
        
        if position < instructions.count {
            setup()
        } else {
            setSubview(trial1View, next: completeView)
        }
    }
    
    func createPostObject() -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        var jsonTask = [AnyObject]()
        var jsonTaskObject = [String: AnyObject]()
        
        for i in 0...position-1 {
            let soundData = FileManager.default.contents(atPath: getCacheDirectory().stringByAppendingPathComponent("wordlist\(i).m4a"))
            let dataStr = soundData?.base64EncodedString(options: [])
            
            jsonTaskObject = [
                "name": "wordlist\(i+1)" as AnyObject,
                "soundByte": dataStr as AnyObject
            ]
            
            jsonTask.append(jsonTaskObject as AnyObject)
        }
        
        
        // Gather data for post
        jsonObject = [
            "id": participant.string(forKey: "pid")! as AnyObject,
            "task": jsonTask as AnyObject
        ]
        
        return jsonObject
    }
    
    // MARK: - Delegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NSLog("finished playing")
        finishPlaying()
    }
}
