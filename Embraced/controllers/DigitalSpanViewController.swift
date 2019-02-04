//
//  DigitalSpanViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class DigitalSpanViewController: FrontViewController {

    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var introView: UIView!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var doneBtn: NavigationButton!
    
    @IBOutlet weak var listenBtn: UIButton!
    @IBOutlet weak var recordPracticeBtn: UIButton!
    @IBOutlet weak var listenForwardBtn: UIButton!
    @IBOutlet weak var recordForwardBtn: UIButton!
    @IBOutlet weak var forwardBtn: NavigationButton!
    @IBOutlet weak var listenPracticeBtn2: UIButton!
    @IBOutlet weak var recordPracitceBtn2: UIButton!
    @IBOutlet weak var listenBackwardBtn: UIButton!
    @IBOutlet weak var recordBackwardBtn: UIButton!
    @IBOutlet weak var backwardBtn: NavigationButton!
    
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
    @IBOutlet weak var practiceNextBtn: NavigationButton!
    @IBOutlet weak var practice2Label: UILabel!
    @IBOutlet weak var practice2instructions: UILabel!
    @IBOutlet weak var practice2NextBtn: NavigationButton!
    @IBOutlet weak var practice3Label: UILabel!
    @IBOutlet weak var practice3Instructions: UILabel!
    @IBOutlet weak var completeLabel: UILabel!
    
    @IBOutlet weak var submit: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var audioRecorder: AVAudioRecorder!
    var recordedAudioURL: URL!
    var fileName = "testDigitSpanAudioFile.m4a"
    
    var stimuli = [String: Any]()
    var forward = [String]()
    var forwardPractice = String()
    var backward = [String]()
    var backwardPractice = String()
    
    var forwardCount = 1
    var backwardCount = 1
    let APIUrl = "http://www.embracedapi.ugr.es/"
    let userDefaults = UserDefaults.standard
    var token: String = ""
    var id: String = ""
    var headers: HTTPHeaders = [:]
    
    let group = DispatchGroup()
    
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
//        showOrientationAlert(orientation: "portrait")
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        // Insert row in database        
        id = participant.string(forKey: "pid")!
        token = userDefaults.string(forKey: "token")!
        headers = [
            "x-access-token": token
        ]
        
        Alamofire.request(APIUrl + "api/digit_span/new/" + id, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        }
        
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
        
        forward = DataManager.sharedInstance.digitalSpanForward
        forwardPractice = DataManager.sharedInstance.digitalSpanForwardPractice
        backward = DataManager.sharedInstance.digitalSpanBackward
        backwardPractice = DataManager.sharedInstance.digitalSpanBackwardPractice
        practice1Label.text = "Practice".localized(lang: language)
        practice1Instructions.text = "digital_practice_1".localized(lang: language)
        recordBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        playBtn.setTitle("Play".localized(lang: language), for: .normal)
        doneBtn.setTitle("Done".localized(lang: language), for: .normal)
        practice2Label.text = "Practice".localized(lang: language)
        listenBtn.setTitle("Listen".localized(lang: language), for: .normal)
        recordPracticeBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        recordPracitceBtn2.setTitle("Start_Record".localized(lang: language), for: .normal)
        recordForwardBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        recordBackwardBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        listenForwardBtn.setTitle("Listen".localized(lang: language), for: .normal)
        listenBackwardBtn.setTitle("Listen".localized(lang: language), for: .normal)
        practiceNextBtn.setTitle("Done".localized(lang: language), for: .normal)
        practice2instructions.text = "digital_practice_2".localized(lang: language)
        rounds.text = "Round".localized(lang: language) + " 1"
        forwardBtn.setTitle("Next".localized(lang: language), for: .normal)
        backwardBtn.setTitle("Next".localized(lang: language), for: .normal)
        
        playBtn.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(.all)
    }
    
    func startRecording(_ button: UIButton, fileName: String) {
        let audioFilename = Utility.getDocumentsDirectory().appendingPathComponent(fileName)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        recordedAudioURL = audioFilename
        
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(true)
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
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
        
//        do {
//            soundRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
//            soundRecorder.delegate = self
//            soundRecorder.record()
//
//            button.setTitle("Stop_Recording".localized(lang: language), for: .normal)
//        } catch {
//            finishRecording(button, success: false)
//        }
    }
    
    func finishRecording(_ button: UIButton, success: Bool) {
//        if soundRecorder.isRecording {
//            soundRecorder.stop()
//            soundRecorder = nil
//        }
        
        audioRecorder.stop()
        audioRecorder = nil
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        if success {
            button.setTitle("Start_Record".localized(lang: language), for: .normal)
            playBtn.isEnabled = true
        }
    }
    
    func finishedPlaying() {
        recordPracticeBtn.isEnabled = true
        recordForwardBtn.isEnabled = true
        recordPracitceBtn2.isEnabled = true
        recordBackwardBtn.isEnabled = true
    }
    
    func postToAPI(object: [String: AnyObject]) {
        let name = object["name"] as! String
        let fileURL = object["audio"] as! URL
        
        // Testing Firebase storage
//        FirebaseStorageManager.sharedInstance.storeDigitSpan(data: object)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(fileURL, withName: "audio")
                multipartFormData.append(name.data(using: String.Encoding.utf8)!, withName: "name")
        }, usingThreshold: UInt64.init(),
           to: APIUrl + "api/digit_span/uploadfile/" + id,
           method: .post,
           headers: headers,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self.deleteAudioFile(fileURL: fileURL)
                }
            case .failure(let encodingError):
                print(encodingError)
            }})
    }
    
//    override func play(_ filename: String) {
//        let audioFilename = getDocumentsDirectory().appendingPathComponent(filename)
//
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
//            audioPlayer.delegate = self
//            audioPlayer.play()
//        } catch {
//            print("No Audio")
//        }
//    }
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        AppDelegate.position += 1
        AppDelegate.testPosition += 1
        self.navigationController?.pushViewController(TestOrder.sharedInstance.getTest(AppDelegate.testPosition), animated: true)
    }

    @IBAction func done(_ sender:AnyObject) {
//        showOverlay()
        
        // Push to the API
//        postToAPI()
        self.next(self)
    }
    // MARK: - Actions
    
    @IBAction func recordTapped(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording(sender, fileName: fileName)
        } else {
            finishRecording(sender, success: true)
            recordPracticeBtn.isEnabled = false
            recordForwardBtn.isEnabled = false
            recordPracitceBtn2.isEnabled = false
            recordBackwardBtn.isEnabled = false
            practiceNextBtn.isHidden = false
            practice2NextBtn.isHidden = false
        }
    }
    
    @IBAction func recordForward(_ sender: AnyObject) {
        if audioRecorder == nil {
            startRecording(sender as! UIButton, fileName: "forward\(forwardCount).m4a")
        } else {
            finishRecording(sender as! UIButton, success: true)
            recordPracticeBtn.isEnabled = false
            recordForwardBtn.isEnabled = false
            recordPracitceBtn2.isEnabled = false
            recordBackwardBtn.isEnabled = false
            forwardBtn.isHidden = false
        }
    }
    
    @IBAction func recordBackward(_ sender: AnyObject) {
        if audioRecorder == nil {
            startRecording(sender as! UIButton, fileName: "backward\(backwardCount).m4a")
        } else {
            finishRecording(sender as! UIButton, success: true)
            recordPracticeBtn.isEnabled = false
            recordForwardBtn.isEnabled = false
            recordPracitceBtn2.isEnabled = false
            recordBackwardBtn.isEnabled = false
            backwardBtn.isHidden = false
        }
    }

    @IBAction func playSound(_ sender: UIButton) {
        if sender.titleLabel!.text == "Play".localized(lang: language) {
            recordBtn.isEnabled = false
            sender.setTitle("Stop".localized(lang: language), for: .normal)
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
    
    @IBAction func listenToSound(_ sender: AnyObject) {
        listenBtn.isEnabled = false
        listenForwardBtn.isEnabled = false
        listenBackwardBtn.isEnabled = false
        listenPracticeBtn2.isEnabled = false
        
        if sender.tag == 0 {
            play(forwardPractice)
        } else if sender.tag == 1 {
            play(forward[forwardCount - 1])
        } else if sender.tag == 2 {
            play(backwardPractice)
        } else if sender.tag == 3 {
            play(backward[backwardCount - 1])
        }
    }
    
    @IBAction func moveToListen(_ sender: AnyObject) {
        setSubview(introView, next: preTask1View)
        recordPracticeBtn.isEnabled = false
        listenBtn.isEnabled = true
        practice2Label.text = "Practice".localized(lang: language)
        practice2instructions.text = "digital_practice_2".localized(lang: language)
        practiceNextBtn.isHidden = true
    }
    
    @IBAction func moveToForward(_ sender: AnyObject) {
        setSubview(preTask1View, next: task1View)
        listenForwardBtn.isEnabled = true
        recordForwardBtn.isEnabled = false
        instructionsA.text = "digital_begin_round".localized(lang: language)
        forwardBtn.isHidden = true
    }
    
    @IBAction func nextSound(_ sender: AnyObject) {
        instructionsA.text = "digital_begin_round_start".localized(lang: language)
        postToAPI(object: createPostObject(direction: "F", index: forwardCount))
        
        if (forwardCount < forward.count) {
            forwardCount += 1
            rounds.text = "Round".localized(lang: language) + " " + String(forwardCount)
            listenForwardBtn.isEnabled = true
            recordForwardBtn.isEnabled = false
            forwardBtn.isHidden = true
        } else {
            setSubview(task1View, next: preTask2View)
            listenPracticeBtn2.isEnabled = true
            recordPracitceBtn2.isEnabled = false
            practice3Label.text = "Practice".localized(lang: language)
            practice3Instructions.text = "digital_practice_3".localized(lang: language)
            practice2NextBtn.isHidden = true
        }
    }
    
    @IBAction func moveToBackward(_ sender: AnyObject) {
        setSubview(preTask2View, next: task2View)
        bRounds.text = "Round".localized(lang: language) + " " + String(backwardCount)
        listenBackwardBtn.isEnabled = true
        recordBackwardBtn.isEnabled = false
        instructions.text = "digital_begin_round2".localized(lang: language)
        backwardBtn.isHidden = true
    }
    
    @IBAction func nextBSound(_ sender: AnyObject) {
        instructions.text = "digital_begin_round2_start".localized(lang: language)
        postToAPI(object: createPostObject(direction: "B", index: backwardCount))
        
        if (backwardCount < backward.count) {
            backwardCount += 1
            bRounds.text = "Round".localized(lang: language) + " " + String(backwardCount)
            listenBackwardBtn.isEnabled = true
            recordBackwardBtn.isEnabled = false
            backwardBtn.isHidden = true
        } else {
            setSubview(task2View, next: completeView)
            completeLabel.text = "Test_complete".localized(lang: language)
            submit.setTitle("Submit".localized(lang: language), for: .normal)
        }
    }
    
    func createPostObject(direction: String, index: Int) -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        var directionName = ""
        
        if direction == "F" {
            directionName = "forward"
        } else if direction == "B" {
            directionName = "backward"
        }
        
        print(directionName + "\(index).m4a")
        
        if fileExist(directionName + "\(index).m4a") {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(directionName)\(index).m4a")
            
            jsonObject = [
                "name": "\(directionName)\(index)" as AnyObject,
                "audio": fileURL as AnyObject
            ]
        }
        
        return jsonObject
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            recordBtn.isEnabled = true
            playBtn.setTitle("Play".localized(lang: language), for: .normal)
            playBtn.isEnabled = false
            listenBtn.isEnabled = true
            recordPracticeBtn.isEnabled = true
            recordForwardBtn.isEnabled = true
        } else {
            print("Player failed")
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}

extension DigitalSpanViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Finished recording")
            recordBtn.isEnabled = true
            playBtn.setTitle("Play".localized(lang: language), for: .normal)
            finishedPlaying()
        } else {
            print("Recording failed")
        }
    }
}
