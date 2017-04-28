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
    var tasks = Array<String>()
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(WordListViewController.next(_:)))
        
        // Insert row in database
        let myCompletionHandler: (Data?, URLResponse?, Error?) -> Void = {
            (data, response, error) in
            // this is where the completion handler code goes
            if let response = response {
                print(response)
            }
            if let error = error {
                print(error)
            }
        }
        APIWrapper.post2(id: participant.string(forKey: "pid")!, test: "wordlist2", data: ["id": participant.string(forKey: "pid")! as AnyObject], callback: myCompletionHandler)
        
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
//        tasks = DataManager.sharedInstance.wordListTasks
        let todoEndpoint: String = "http://api.girlscouts.harryatwal.com/stimuli/wordlist2"
        
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
                    
                    self.tasks = todo[trial]! as! Array<String>
                    
                } catch {
                    //                    print("Error with Json: \(error)")
                    return
                }
            }
        })
        
        task.resume()

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
        let soundData = FileManager.default.contents(atPath: getCacheDirectory().stringByAppendingPathComponent("wordlistRecall.m4a"))
        let dataStr = soundData?.base64EncodedString(options: [])
        var jsonObject = [String: AnyObject]()
        
        // Gather data for post
        jsonObject = [
            "soundByte": dataStr as AnyObject
        ]
        
        return jsonObject
    }
    
    func createPostObject2(index: Int, answer: String) -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        
        // Gather data for post
        jsonObject = [
            "index": index as AnyObject,
            "answers": answer as AnyObject,
        ]
        
        return jsonObject
    }
    
    func postToAPI(object: [String: AnyObject]) {
        // Completion Handler
        let myCompletionHandler: (Data?, URLResponse?, Error?) -> Void = {
            (data, response, error) in
            // this is where the completion handler code goes
            if let response = response {
                print(response)
                // Clear audios
                self.deleteFile("wordlistRecall.m4a")
                print("Deleted temp file")
                print("Done")
//                DispatchQueue.main.async(execute: {
//                    self.hideOverlayView()
//                    self.next(self)
//                })
                
            }
            if let error = error {
                print(error)
            }
        }
        
        APIWrapper.post2(id: participant.string(forKey: "pid")!, test: "wordlist2", data: object, callback: myCompletionHandler)
    }
    
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        AppDelegate.position += 1
        nextViewController2(position: AppDelegate.position)
    }
    
    @IBAction func done(_ sender: AnyObject) {
//        showOverlay()
        
        // Push to the API
        self.next(self)
    }
    
    @IBAction func moveToRecogniton(_ sender: AnyObject) {
        postToAPI(object: createPostObject())
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
        var a: String
        
        switch answer {
            case 0: a = "Yes"
            case 1: a = "No"
            default: a = ""
        }
        
        
        wordNext2Btn.isHidden = true
        
        position += 1
        
        postToAPI(object: createPostObject2(index: position, answer: a))
        
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
