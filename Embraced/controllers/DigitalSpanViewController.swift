//
//  DigitalSpanViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation

class DigitalSpanViewController: FrontViewController, AVAudioRecorderDelegate {

    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var introView: UIView!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var listenBtn: UIButton!
    @IBOutlet weak var recordPracticeBtn: UIButton!
    @IBOutlet weak var listenForwardBtn: UIButton!
    @IBOutlet weak var recordForwardBtn: UIButton!
    @IBOutlet weak var listenPracticeBtn2: UIButton!
    @IBOutlet weak var recordPracitceBtn2: UIButton!
    @IBOutlet weak var listenBackwardBtn: UIButton!
    @IBOutlet weak var recordBackwardBtn: UIButton!
    
    @IBOutlet var preTask1View: UIView!
    @IBOutlet var task1View: UIView!
    @IBOutlet var preTask2View: UIView!
    @IBOutlet var task2View: UIView!
    @IBOutlet var completeView: UIView!
    
    @IBOutlet weak var rounds: UILabel!
    @IBOutlet weak var bRounds: UILabel!
    
    @IBOutlet weak var instructionsA: UILabel!
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var practice1Label: UILabel!
    @IBOutlet weak var practice1Instructions: UILabel!
    @IBOutlet weak var practice2Label: UILabel!
    @IBOutlet weak var practice2instructions: UILabel!
    @IBOutlet weak var practice3Label: UILabel!
    @IBOutlet weak var practice3Instructions: UILabel!
    @IBOutlet weak var completeLabel: UILabel!
    
    @IBOutlet weak var submit: UIButton!
    var recordingSession: AVAudioSession!
    
    var soundRecorder: AVAudioRecorder!
    var fileName = "testDigitSpanAudioFile.m4a"
    
    var stimuli = [String: Any]()
    var forward = Array<String>()
    var backward = Array<String>()
    
    
    var forwardCount = 0
    var backwardCount = 0
    
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
        
        orientation = "portrait"
        rotated()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(DigitalSpanViewController.next(_:)))
        
        introView.translatesAutoresizingMaskIntoConstraints = false
        preTask1View.translatesAutoresizingMaskIntoConstraints = false
        preTask2View.translatesAutoresizingMaskIntoConstraints = false
        task1View.translatesAutoresizingMaskIntoConstraints = false
        task2View.translatesAutoresizingMaskIntoConstraints = false
        completeView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(introView)
        
        let leftConstraint = introView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let topConstraint = introView.topAnchor.constraint(equalTo: containerView.topAnchor)
        let rightConstraint = introView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottomConstraint = introView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
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

        forward = DataManager.sharedInstance.digitalSpanForward
        backward = DataManager.sharedInstance.digitalSpanBackward
        
//        let pathResource = Bundle.main.path(forResource: "melodies 320ms orig(16)", ofType: "wav")
//        let finishedStepSound = URL(fileURLWithPath: pathResource!)
//        
//        do {
//            soundPlayer = try AVAudioPlayer(contentsOf: finishedStepSound)
//            if(soundPlayer?.prepareToPlay())!{
//                print("preparation success")
//                soundPlayer?.delegate = self
//            }else{
//                print("preparation failure")
//            }
//            
//        }catch{
//            print("Sound file could not be found")
//        }
        
        loadingView.stopAnimating()
        
        practice1Label.text = "Practice".localized(lang: participant.string(forKey: "language")!)
        practice1Instructions.text = "digital_practice_1".localized(lang: participant.string(forKey: "language")!)
        playBtn.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            button.setTitle("Stop_Recording".localized(lang: participant.string(forKey: "language")!), for: .normal)
        } catch {
            finishRecording(button, success: false)
        }
    }
    
    func finishRecording(_ button: UIButton, success: Bool) {
        if soundRecorder.isRecording {
            soundRecorder.stop()
            soundRecorder = nil
        }
        
        if success {
            button.setTitle("Start_Record".localized(lang: participant.string(forKey: "language")!), for: .normal)
            playBtn.isEnabled = true
        }
    }
    
    
    func preparePlayer() {
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: getDocumentsDirectory().appendingPathComponent(fileName))
            soundPlayer?.delegate = self
            soundPlayer?.prepareToPlay()
            soundPlayer?.volume = 1.0
        } catch {
            log(logMessage: "Something went wrong")
        }
    }
    
    func log(logMessage: String, functionName: String = #function) {
        print("\(#function): \(logMessage)")
    }
    
    func finishedPlaying() {
        recordPracticeBtn.isEnabled = true
        listenBtn.isEnabled = false
        
        listenForwardBtn.isEnabled = false
        recordForwardBtn.isEnabled = true
        
        listenPracticeBtn2.isEnabled = false
        recordPracitceBtn2.isEnabled = true
        
        listenBackwardBtn.isEnabled = false
        recordBackwardBtn.isEnabled = true
    }
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        AppDelegate.position += 1
        nextViewController2(position: AppDelegate.position)
    }

    @IBAction func done(_ sender:AnyObject) {
        // Push to API
        APIWrapper.post(id: participant.string(forKey: "pid")!, test: "digitalSpan", data: createPostObject())
        
        next(self)
    }
    // MARK: - Actions
    
    @IBAction func recordTapped(_ sender: UIButton) {
        if soundRecorder == nil {
            startRecording(sender, fileName: fileName)
        } else {
            finishRecording(sender, success: true)
            recordPracticeBtn.isEnabled = false
            recordForwardBtn.isEnabled = false
            recordPracitceBtn2.isEnabled = false
            recordBackwardBtn.isEnabled = false
        }
    }
    
    @IBAction func recordForward(_ sender: AnyObject) {
        if soundRecorder == nil {
            startRecording(sender as! UIButton, fileName: "forward\(forwardCount).m4a")
        } else {
            finishRecording(sender as! UIButton, success: true)
            recordPracticeBtn.isEnabled = false
            recordForwardBtn.isEnabled = false
            recordPracitceBtn2.isEnabled = false
            recordBackwardBtn.isEnabled = false
        }
    }
    
    @IBAction func recordBackward(_ sender: AnyObject) {
        if soundRecorder == nil {
            startRecording(sender as! UIButton, fileName: "backward\(backwardCount).m4a")
        } else {
            finishRecording(sender as! UIButton, success: true)
            recordPracticeBtn.isEnabled = false
            recordForwardBtn.isEnabled = false
            recordPracitceBtn2.isEnabled = false
            recordBackwardBtn.isEnabled = false
        }
    }

    
    @IBAction func playSound(_ sender: UIButton) {
        if sender.titleLabel!.text == "Play" {
            recordBtn.isEnabled = false
            sender.setTitle("Stop".localized(lang: participant.string(forKey: "language")!), for: UIControlState())
            preparePlayer()
            soundPlayer?.play()
        } else {
            if (soundPlayer?.isPlaying)! {
                soundPlayer?.stop()
            }
            sender.setTitle("Play".localized(lang: participant.string(forKey: "language")!), for: UIControlState())
        }
    }
    
    @IBAction func listenToSound(_ sender: AnyObject) {
        if sender.tag == 0 {
            play(forward[forward.count - 1])
        } else if sender.tag == 1 {
            play(forward[forwardCount])
        } else if sender.tag == 2 {
            play(backward[backward.count - 1])
        } else if sender.tag == 3 {
            play(backward[backwardCount])
        }
    }
    
    @IBAction func moveToListen(_ sender: AnyObject) {
        setSubview(introView, next: preTask1View)
        recordPracticeBtn.isEnabled = false
        listenBtn.isEnabled = true
        practice2Label.text = "Practice".localized(lang: participant.string(forKey: "language")!)
        practice2instructions.text = "digital_practice_2".localized(lang: participant.string(forKey: "language")!)
    }
    
    @IBAction func moveToForward(_ sender: AnyObject) {
        setSubview(preTask1View, next: task1View)
        listenForwardBtn.isEnabled = true
        recordForwardBtn.isEnabled = false
        instructionsA.text = "digital_begin_round".localized(lang: participant.string(forKey: "language")!)
    }
    
    @IBAction func nextSound(_ sender: AnyObject) {
        instructionsA.text = "digital_begin_round_start".localized(lang: participant.string(forKey: "language")!)
        if (forwardCount < forward.count - 2) {
            forwardCount += 1
            rounds.text = "Round".localized(lang: participant.string(forKey: "language")!) + " " + String(forwardCount+1)
            listenForwardBtn.isEnabled = true
            recordForwardBtn.isEnabled = false
        } else {
            setSubview(task1View, next: preTask2View)
            listenPracticeBtn2.isEnabled = true
            recordPracitceBtn2.isEnabled = false
            practice3Label.text = "Practice".localized(lang: participant.string(forKey: "language")!)
            practice3Instructions.text = "digital_practice_3".localized(lang: participant.string(forKey: "language")!)
        }
    }
    
    @IBAction func moveToBackward(_ sender: AnyObject) {
        setSubview(preTask2View, next: task2View)
        bRounds.text = "Round".localized(lang: participant.string(forKey: "language")!) + " " + String(backwardCount+1)
        listenBackwardBtn.isEnabled = true
        recordBackwardBtn.isEnabled = false
        instructions.text = "digital_begin_round2".localized(lang: participant.string(forKey: "language")!)
    }
    
    @IBAction func nextBSound(_ sender: AnyObject) {
        instructions.text = "digital_begin_round2_start".localized(lang: participant.string(forKey: "language")!)
        if (backwardCount < backward.count - 2) {
            backwardCount += 1
            bRounds.text = "Round".localized(lang: participant.string(forKey: "language")!) + " " + String(backwardCount+1)
            listenBackwardBtn.isEnabled = true
            recordBackwardBtn.isEnabled = false
        } else {
            setSubview(task2View, next: completeView)
            completeLabel.text = "Test_complete".localized(lang: participant.string(forKey: "language")!)
            submit.setTitle("Submit".localized(lang: participant.string(forKey: "language")!), for: .normal)
        }
    }
    
    func createPostObject() -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        var jsonForward = [AnyObject]()
        var jsonForwardObject = [String: AnyObject]()
        var jsonBackward = [AnyObject]()
        var jsonBackwardObject = [String: AnyObject]()
        

        for i in 0...forwardCount {
            let soundData = FileManager.default.contents(atPath: getCacheDirectory().stringByAppendingPathComponent("forward\(i).m4a"))
//            print(soundData! as NSData)
            let dataStr = soundData?.base64EncodedString(options: [])
//            print(dataStr! as String)
            
            jsonForwardObject = [
                "name": "forward\(i+1)" as AnyObject,
                "soundByte": dataStr as AnyObject
            ]
            
            jsonForward.append(jsonForwardObject as AnyObject)
        }
        
        for i in 0...backwardCount {
            let soundData = FileManager.default.contents(atPath: getCacheDirectory().stringByAppendingPathComponent("backward\(i).m4a"))
            let dataStr = soundData?.base64EncodedString(options: [])
            
            jsonBackwardObject = [
                "name": "backward\(i+1)" as AnyObject,
                "soundByte": dataStr as AnyObject
            ]
            
            jsonBackward.append(jsonBackwardObject as AnyObject)
        }
        
    
        // Gather data for post
        jsonObject = [
            "id": participant.string(forKey: "pid")! as AnyObject,
            "forward": jsonForward as AnyObject,
            "backward": jsonBackward as AnyObject
        ]
    
        return jsonObject
    }
    
    
    // MARK: - Delegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBtn.isEnabled = true
        playBtn.setTitle("Play".localized(lang: participant.string(forKey: "language")!), for: UIControlState())
        finishedPlaying()
    }
}
