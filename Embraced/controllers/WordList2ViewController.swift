//
//  WordList2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/8/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class WordList2ViewController: FrontViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet var practiceView: UIView!
    @IBOutlet var recognitionView: UIView!
    @IBOutlet var completeView: UIView!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var firstListLabel: UILabel!
    @IBOutlet weak var listenBtn: UIButton!
    @IBOutlet weak var answerSegment: UISegmentedControl!
    
    @IBOutlet weak var instructionText: UILabel!
    @IBOutlet weak var instructionText2: UILabel!
    
    var recordingSession: AVAudioSession!
    var soundRecorder: AVAudioRecorder!
    var fileName : String = "wordlistRecall.m4a"
    var tasks = Array<String>()
    var startTime = TimeInterval()
    var timer = Timer()
    var count = 3
    var position = 0
    var answers = [String]()
    var answer = String()
    
    let myString: String = "Some time ago you listened to a list of words 5 times. Now say out loud all the words you can remember from that list. \nTap the microphone button to start recording."
    let myString2: String = "Now you will hear a longer list of words, one by one.\nIf the word is one of the words in the first list you heard, the on you heard 5 times, click the button “YES”\nIf the word was NOT in the first list, the one you heard 5 times, click the button “NO”.\nTap the LISTEN icon to start"
    var myMutableString = NSMutableAttributedString()
    var myMutableString2 = NSMutableAttributedString()
    
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
        step = 17
        
        super.viewDidLoad()
        
        orientation = "landscape"
        rotated()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(WordListViewController.next(_:)))
        
        
        practiceView.translatesAutoresizingMaskIntoConstraints = false
        recognitionView.translatesAutoresizingMaskIntoConstraints = false
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
        tasks = DataManager.sharedInstance.wordListTasks
        
        myMutableString = NSMutableAttributedString(string: myString)
        myMutableString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(46, 7))
        instructionText.attributedText = myMutableString
        
        myMutableString2 = NSMutableAttributedString(string: myString2)
        myMutableString2.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(132, 7))
        myMutableString2.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(221, 7))
        instructionText2.attributedText = myMutableString2
        
        loadingView.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func startRecording(_ button: UIButton) {
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
        if soundRecorder != nil {
            soundRecorder.stop()
            soundRecorder = nil
        }
        
        if success {
            button.setTitle("Re-record", for: .normal)
        } else {
            button.setTitle("Record", for: .normal)
            // recording failed :(
        }
    }
    
//    func play(_ filename:String) {
//        do {
//            let path = Bundle.main.path(forResource: filename, ofType: nil)
//            let url = URL(fileURLWithPath: path!)
//            soundPlayer = try AVAudioPlayer(contentsOf: url)
//            soundPlayer.delegate = self
//            soundPlayer.prepareToPlay()
//            soundPlayer.volume = 1.0
//            soundPlayer.play()
//        } catch let error as NSError {
//            //self.player = nil
//            print(error.localizedDescription)
//        } catch {
//            print("AVAudioPlayer init failed")
//        }
//        
//    }
    
    func finishPlaying() {
        if soundPlayer.isPlaying {
            soundPlayer.stop()
        }
        
        firstListLabel.isHidden = false
        answerSegment.isHidden = false
        listenBtn.isEnabled = false
    }
    
    
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        let vc:NamingTaskViewController = NamingTaskViewController()
        nextViewController(viewController: vc)
    }
    
    @IBAction func done(_ sender: AnyObject) {
        let soundData = FileManager.default.contents(atPath: getCacheDirectory().stringByAppendingPathComponent("wordlistRecall.m4a"))
        let dataStr = soundData?.base64EncodedString(options: [])
        var jsonObject = [String: AnyObject]()
        
        // Gather data for post
        jsonObject = [
            "answers": answers as AnyObject,
            "soundByte": dataStr as AnyObject
        ]
        
        APIWrapper.post(id: participant.string(forKey: "pid")!, test: "wordlist2", data: jsonObject)
        
        next(self)
    }
    
    @IBAction func moveToRecogniton(_ sender: AnyObject) {
        setSubview(practiceView, next: recognitionView)
        listenBtn.isEnabled = true
        firstListLabel.isHidden = true
        answerSegment.isHidden = true
    }
    
    
    // MARK: - Action
    
    @IBAction func recordTapped(_ sender: UIButton) {
        if soundRecorder == nil {
            startRecording(sender)
        } else {
            finishRecording(button: sender, success: true)
        }
    }
    
    @IBAction func listen(_ sender: AnyObject) {
        self.play(tasks[position])
        listenBtn.isEnabled = false
    }

    @IBAction func answerSegment(_ sender: UISegmentedControl) {
        answer = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }

    @IBAction func nextQuestion(_ sender: UISegmentedControl) {
        answers.insert(answer, at: position)
        print(answers)
        position += 1
        
        if position == tasks.count {
            setSubview(recognitionView, next: completeView)
        } else {
            listenBtn.isEnabled = true
            firstListLabel.isHidden = true
            answerSegment.isHidden = true
            answerSegment.selectedSegmentIndex = -1
        }
    }
    
    
    
    // MARK: - Delegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NSLog("finished playing")
        finishPlaying()
    }
}
