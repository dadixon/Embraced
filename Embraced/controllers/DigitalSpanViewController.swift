//
//  DigitalSpanViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation

class DigitalSpanViewController: FrontViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    
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
    
    var recordingSession: AVAudioSession!
    
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    var fileName = "testAudioFile.m4a"
    
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
        step = 8
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
        
        loadingView.stopAnimating()
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
            let soundR = try AVAudioRecorder(url: audioFilename, settings: settings)
            soundR.delegate = self
            soundRecorder = soundR
            soundR.record()
            
            button.setTitle("Stop", for: .normal)
        } catch {
            finishRecording(button, success: false)
        }
    }
    
    func finishRecording(_ button: UIButton, success: Bool) {
        soundRecorder.stop()
        soundRecorder = nil
        
        if success {
            button.setTitle("Start", for: .normal)
        }
    }
    
    
    func preparePlayer() {
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: getDocumentsDirectory().appendingPathComponent(fileName))
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            log(logMessage: "Something went wrong")
        }
    }
    
    func play(_ filename:String) {
        do {
            let path = Bundle.main.path(forResource: filename, ofType: nil)
            let url = URL(fileURLWithPath: path!)
            let sound = try AVAudioPlayer(contentsOf: url)
            sound.delegate = self
            sound.prepareToPlay()
            sound.volume = 1.0
            soundPlayer = sound
            sound.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
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
        let vc:ReyComplexFigure3ViewController = ReyComplexFigure3ViewController()
        nextViewController(viewController: vc)
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
        }
    }
    
    @IBAction func recordForward(_ sender: AnyObject) {
        if soundRecorder == nil {
            startRecording(sender as! UIButton, fileName: "forward\(forwardCount).m4a")
        } else {
            finishRecording(sender as! UIButton, success: true)
        }
    }
    
    @IBAction func recordBackward(_ sender: AnyObject) {
        if soundRecorder == nil {
            startRecording(sender as! UIButton, fileName: "backward\(backwardCount).m4a")
        } else {
            finishRecording(sender as! UIButton, success: true)
        }
    }

    
    @IBAction func playSound(_ sender: UIButton) {
        if sender.titleLabel!.text == "Play" {
            recordBtn.isEnabled = false
            sender.setTitle("Stop", for: UIControlState())
            preparePlayer()
            soundPlayer.play()
        } else {
            if soundPlayer != nil {
                soundPlayer.stop()
                soundPlayer = nil
            }
            sender.setTitle("Play", for: UIControlState())
        }
    }
    
    @IBAction func listenToSound(_ sender: AnyObject) {
        if sender.tag == 0 {
            self.play(forward[forward.count - 1])
        } else if sender.tag == 1 {
            self.play(forward[forwardCount])
        } else if sender.tag == 2 {
            self.play(backward[backward.count - 1])
        } else if sender.tag == 3 {
            self.play(backward[backwardCount])
        }
    }
    
    @IBAction func moveToListen(_ sender: AnyObject) {
        setSubview(introView, next: preTask1View)
        recordPracticeBtn.isEnabled = false
        listenBtn.isEnabled = true
    }
    
    @IBAction func moveToForward(_ sender: AnyObject) {
        setSubview(preTask1View, next: task1View)
        listenForwardBtn.isEnabled = true
        recordForwardBtn.isEnabled = false
    }
    
    @IBAction func nextSound(_ sender: AnyObject) {
        instructionsA.text = "Click on LISTEN button when you are ready."
        if (forwardCount < forward.count - 2) {
            forwardCount += 1
            rounds.text = "Round \(forwardCount+1)"
            listenForwardBtn.isEnabled = true
            recordForwardBtn.isEnabled = false
        } else {
            setSubview(task1View, next: preTask2View)
            listenPracticeBtn2.isEnabled = true
            recordPracitceBtn2.isEnabled = false
        }
    }
    
    @IBAction func moveToBackward(_ sender: AnyObject) {
        setSubview(preTask2View, next: task2View)
        bRounds.text = "Round \(backwardCount+1)"
        listenBackwardBtn.isEnabled = true
        recordBackwardBtn.isEnabled = false
    }
    
    @IBAction func nextBSound(_ sender: AnyObject) {
        instructions.text = "Click on LISTEN button when you are ready."
        if (backwardCount < backward.count - 2) {
            backwardCount += 1
            bRounds.text = "Round \(backwardCount+1)"
            listenBackwardBtn.isEnabled = true
            recordBackwardBtn.isEnabled = false
        } else {
            setSubview(task2View, next: completeView)
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
        playBtn.setTitle("Play", for: UIControlState())
        finishedPlaying()
    }
}
