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
    @IBOutlet weak var InstructionsLabel: UILabel!
    @IBOutlet weak var instructions2Label: UILabel!
    @IBOutlet weak var listenBtn: UIButton!
    @IBOutlet weak var practiceLabel: UILabel!
    @IBOutlet weak var practiceInstruction: UILabel!
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var startBtn: NavigationButton!
    @IBOutlet weak var wordNextBtn: NavigationButton!
    
    
    var recordingSession: AVAudioSession!
    
    var soundRecorder: AVAudioRecorder!
    var fileName : [String] = ["testWordlistAudioFile.m4a", "trial1.m4a", "trial2.m4a", "trial3.m4a", "trial4.m4a", "trial5.m4a"]
    
    var startTime = TimeInterval()
    var timer = Timer()
    var count = 3
    var trials = Array<String>()
    var sound = String()
    var practice = true
    var position = 0
    var instructions = Array<String>()
    var instructions2 = Array<String>()
    var language = String()
    
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
        
        language = participant.string(forKey: "language")!
        
        showOrientationAlert(orientation: "landscape")
        
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
//        trials = DataManager.sharedInstance.wordListTrials
        let todoEndpoint: String = "http://api.girlscouts.harryatwal.com/stimuli/wordlist"
        
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
                    
                    var language = "en"
                    var trial = ""
                    
                    if self.participant.string(forKey: "language") != nil {
                        language = self.participant.string(forKey: "language")!
                    }
                    
                    if language == "en" {
                        trial = "trials"
                    } else if language == "es" {
                        trial = "trialsSp"
                    }
                    
                    self.trials = todo[trial]! as! Array<String>
                    
                } catch {
                    //                    print("Error with Json: \(error)")
                    return
                }
            }
        })
        
        task.resume()
        
        practiceLabel.text = "Practice".localized(lang: language)
        practiceInstruction.text = "wordlist1_practice_instruction".localized(lang: language)
        startBtn.setTitle("Start".localized(lang: language), for: .normal)
        recordBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        playBtn.setTitle("Play".localized(lang: language), for: .normal)
        trialLabel.text = "Trial".localized(lang: language) + " 1"
        listenBtn.setTitle("Listen".localized(lang: language), for: .normal)
        trialRecordBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        wordNextBtn.setTitle("Done".localized(lang: language), for: .normal)
        instructions = ["wordlist1_instructionA1".localized(lang: language),
                                       "wordlist1_instructionA2".localized(lang: language),
                                       "wordlist1_instructionA2".localized(lang: language),
                                       "wordlist1_instructionA2".localized(lang: language),
                                       "wordlist1_instructionA3".localized(lang: language),
                                       "wordlist1_instructionA4".localized(lang: language),
                                       "wordlist1_instructionA5".localized(lang: language)
        ]
        instructions2 = ["wordlist1_instructionB1".localized(lang: language),
                                        "wordlist1_instructionB2".localized(lang: language),
                                        "wordlist1_instructionB2".localized(lang: language),
                                        "wordlist1_instructionB2".localized(lang: language),
                                        "wordlist1_instructionB2".localized(lang: language),
                                        "wordlist1_instructionB1".localized(lang: language),
                                        ""
        ]
        
        loadingView.stopAnimating()
        
        playBtn.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        instructions2Label.isHidden = true
        
        if position < 5 {
            trialLabel.text = "Trial".localized(lang: language) + " " + String(position + 1)
        } else {
            trialLabel.text = "" //"Interference list"
        }
        
        InstructionsLabel.text = instructions[position]
        instructions2Label.text = instructions2[position]
        trialRecordBtn.isEnabled = false
        listenBtn.isEnabled = true
        
        if position == 6 {
            listenBtn.isHidden = true
            trialRecordBtn.isEnabled = true
        }
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
            
            button.setTitle("Stop_Recording".localized(lang: language), for: .normal)
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
            button.setTitle("Start_Record".localized(lang: language), for: .normal)
            playBtn.isEnabled = true
        }
    }
    
    func finishPlaying() {
        if (soundPlayer?.isPlaying)! {
            soundPlayer?.stop()
        }
        
        if practice {
            playBtn.setTitle("Play".localized(lang: language), for: .normal)
            recordBtn.isEnabled = true
        } else {
            instructions2Label.isHidden = false
            trialRecordBtn.isEnabled = true
            listenBtn.isEnabled = false
        }
    }
    
    func preparePlayer() {
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: getDocumentsDirectory().appendingPathComponent("testWordlistAudioFile.m4a"))
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
        AppDelegate.position += 1
        nextViewController2(position: AppDelegate.position)
    }

    @IBAction func done(_ sender: AnyObject) {
        APIWrapper.post(id: participant.string(forKey: "pid")!, test: "wordlist", data: createPostObject())
        next(self)
        
        // Clear audios
        for i in 0...position-1 {
            deleteFile("wordlist\(i).m4a")
        }
    }
    
    @IBAction func moveToTrial1(_ sender: AnyObject) {
        setSubview(practiceView, next: trial1View)
        setup()
        practice = false
        
        wordNextBtn.setTitle("Next".localized(lang: language), for: .normal)
        wordNextBtn.isHidden = true
    }
    
    
    // MARK: - Action
    
    @IBAction func recordTappedTest(_ sender: UIButton) {
        if soundRecorder == nil {
            startRecording(sender, fileName: "testWordlistAudioFile.m4a")
        } else {
            finishRecording(sender, success: true)
            trialRecordBtn.isEnabled = false
        }
    }
    
    @IBAction func recordTapped(_ sender: UIButton) {
        if soundRecorder == nil {
            startRecording(sender, fileName: "wordlist\(position).m4a")
        } else {
            finishRecording(sender, success: true)
            trialRecordBtn.isEnabled = false
            wordNextBtn.isHidden = false
        }
    }
    
    @IBAction func playSound(_ sender: UIButton) {
        if sender.titleLabel!.text == "Play".localized(lang: language) {
            recordBtn.isEnabled = false
            sender.setTitle("Stop".localized(lang: language), for: UIControlState())
            preparePlayer()
            soundPlayer?.play()
        } else {
            if (soundPlayer?.isPlaying)! {
                soundPlayer?.stop()
            }
            sender.setTitle("Play".localized(lang: language), for: UIControlState())
        }
    }
    
    @IBAction func listen(_ sender: AnyObject) {
        count = 3
        startTimer()
        listenBtn.isEnabled = false
    }
    
    @IBAction func nextTrial(_ sender: AnyObject) {
        position += 1
        
        if soundPlayer != nil {
            if (soundPlayer?.isPlaying)! {
                soundPlayer?.stop()
            }
        }
        
        if position < instructions.count {
            setup()
            wordNextBtn.isHidden = true
        } else {
            setSubview(trial1View, next: completeView)
            
            completeLabel.text = "Test_complete".localized(lang: language)
            completeBtn.setTitle("Submit".localized(lang: language), for: .normal)
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
        print("finished playing")
        finishPlaying()
    }
}
