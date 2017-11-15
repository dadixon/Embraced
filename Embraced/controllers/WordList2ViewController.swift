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
import Alamofire

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
    
    @IBOutlet weak var wordNextBtn: NavigationButton!
    @IBOutlet weak var recognitionLabel: UILabel!
    @IBOutlet weak var instructionText: UILabel!
    @IBOutlet weak var instructionText2: UILabel!
    @IBOutlet weak var wordNext2Btn: NavigationButton!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    
    var recordingSession: AVAudioSession!
    var soundRecorder: AVAudioRecorder!
    var fileName : String = "wordlistRecall.m4a"
    var tasks = [String]()
    var startTime = TimeInterval()
    var timer = Timer()
    var count = 3
    var position = 0
    var answers = [String]()
    var answer = Int()
    
    var myString = ""
    var myString2 = ""
    var myMutableString = NSMutableAttributedString()
    var myMutableString2 = NSMutableAttributedString()
    
    let APIUrl = "http://www.embracedapi.ugr.es/"
    let userDefaults = UserDefaults.standard
    var token: String = ""
    var id: String = ""
    var headers: HTTPHeaders = [:]
    
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
        
        // Insert row in database
        id = participant.string(forKey: "pid")!
        token = userDefaults.string(forKey: "token")!
        headers = [
            "x-access-token": token
        ]
        
        Alamofire.request(APIUrl + "api/wordlist/new/" + id, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        }
        
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
        self.tasks = DataManager.sharedInstance.wordListRecognitions

        instructionText.text = "wordlist2_instruction".localized(lang: participant.string(forKey: "language")!)
        instructionText2.text = "wordlist2_instruction2".localized(lang: participant.string(forKey: "language")!)
        
        recordBtn.setTitle("Start_Record".localized(lang: participant.string(forKey: "language")!), for: .normal)
        wordNextBtn.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
        wordNextBtn.isHidden = true
        
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
            
            button.setTitle("Stop_Recording".localized(lang: participant.string(forKey: "language")!), for: .normal)
        } catch {
            finishRecording(button: button, success: false)
        }
    }
    
    func finishRecording(button: UIButton, success: Bool) {
        if soundRecorder != nil {
            soundRecorder.stop()
            soundRecorder = nil
        }
        
        button.isEnabled = false
    }
    
    func finishPlaying() {
        if (soundPlayer?.isPlaying)! {
            soundPlayer?.stop()
        }
        
        firstListLabel.isHidden = false
        answerSegment.isHidden = false
        listenBtn.isEnabled = false
    }
    
    func createPostObject() -> [String: AnyObject] {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("wordlistRecall.m4a")
        var jsonObject = [String: AnyObject]()
        
        // Gather data for post
        jsonObject = [
            "index": "8" as AnyObject,
            "audio": fileURL as AnyObject
        ]
        
        return jsonObject
    }
    
    func createPostObject2(index: Int, answer: Bool) -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        
        // Gather data for post
        jsonObject = [
            "name": "question\(index)" as AnyObject,
            "answer": answer as AnyObject,
        ]
        
        return jsonObject
    }
    
    func postToAPI(object: [String: AnyObject], audio: Bool) {
        if audio {
            let index = object["index"] as! String
            let fileURL = object["audio"] as! URL
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(fileURL, withName: "audio")
                    multipartFormData.append(index.data(using: String.Encoding.utf8)!, withName: "index")
            }, usingThreshold: UInt64.init(),
               to: APIUrl + "api/wordlist/uploadfile/" + id,
               method: .post,
               headers: headers,
               encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }})
        } else {
            Alamofire.request(APIUrl + "api/wordlist/answers/" + id, method: .post, parameters: object, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                            debugPrint(response)
            }
        }
    }
    
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        AppDelegate.position += 1
        AppDelegate.testPosition += 1
        self.navigationController?.pushViewController(TestOrder.sharedInstance.getTest(AppDelegate.testPosition), animated: true)
    }
    
    @IBAction func done(_ sender: AnyObject) {
//        showOverlay()
        
        // Push to the API
        self.next(self)
    }
    
    @IBAction func moveToRecogniton(_ sender: AnyObject) {
        postToAPI(object: createPostObject(), audio: true)
        setSubview(practiceView, next: recognitionView)
        listenBtn.isEnabled = true
        firstListLabel.isHidden = true
        answerSegment.isHidden = true
        
        recognitionLabel.text = "Recognition".localized(lang: participant.string(forKey: "language")!)
        firstListLabel.text = "wordlist2_in_first_list".localized(lang: participant.string(forKey: "language")!)
        wordNext2Btn.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
        answerSegment.setTitle("Yes".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 0)
        answerSegment.setTitle("No".localized(lang: participant.string(forKey: "language")!), forSegmentAt: 1)
        
        wordNext2Btn.isHidden = true
    }
    
    
    // MARK: - Action
    
    @IBAction func recordTapped(_ sender: UIButton) {
        if soundRecorder == nil {
            startRecording(sender)
        } else {
            finishRecording(button: sender, success: true)
            wordNextBtn.isHidden = false
        }
    }
    
    @IBAction func listen(_ sender: AnyObject) {
        self.play(tasks[position])
        listenBtn.isEnabled = false
    }

    @IBAction func answerSegment(_ sender: UISegmentedControl) {
        answer = sender.selectedSegmentIndex
        wordNext2Btn.isHidden = false
    }

    @IBAction func nextQuestion(_ sender: UISegmentedControl) {
        var a: Bool = false
        
        if answer == 0 {
            a = true
        }
        
        wordNext2Btn.isHidden = true
        
        position += 1
        
        postToAPI(object: createPostObject2(index: position, answer: a), audio: false)
        
        if position == tasks.count {
            setSubview(recognitionView, next: completeView)
            completeLabel.text = "Test_complete".localized(lang: participant.string(forKey: "language")!)
            completeBtn.setTitle("Submit".localized(lang: participant.string(forKey: "language")!), for: .normal)
        } else {
            listenBtn.isEnabled = true
            firstListLabel.isHidden = true
            answerSegment.isHidden = true
            answerSegment.selectedSegmentIndex = -1
        }
        answer = -1;
    }
    
    
    
    // MARK: - Delegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        print("finished playing")
        finishPlaying()
    }
}
