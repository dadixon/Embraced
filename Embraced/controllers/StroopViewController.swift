//
//  StroopViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire

class StroopViewController: FrontViewController, AVAudioRecorderDelegate, AVPlayerViewControllerDelegate {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var introView: UIView!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var practiceLabel: UILabel!
    @IBOutlet weak var practiceInstruction1: UILabel!
    @IBOutlet weak var practiceDoneBtn: NavigationButton!
    
    @IBOutlet var instructionsView: UIView!
    @IBOutlet weak var practiceInstruction2: UILabel!
    @IBOutlet weak var stroopNextBtn: NavigationButton!
    
    @IBOutlet var preTask1View: UIView!
    @IBOutlet var pTask1View: UIView!
    @IBOutlet var task1View: UIView!
    @IBOutlet weak var task1ImageView: UIImageView!
    @IBOutlet weak var preTaskInstruction: UILabel!
    @IBOutlet weak var previewBtn: NavigationButton!
    @IBOutlet weak var nextBtn2: NavigationButton!
    @IBOutlet weak var pTaskLabel: UILabel!
    @IBOutlet weak var pTaskBtn: NavigationButton!
    @IBOutlet weak var recordBtn1: UIButton!
    @IBOutlet weak var doneBtn: NavigationButton!
    
    @IBOutlet var preTask2View: UIView!
    @IBOutlet var pTask2View: UIView!
    @IBOutlet var task2View: UIView!
    @IBOutlet weak var task2ImageView: UIImageView!
    @IBOutlet weak var preTaskInstruction2: UILabel!
    @IBOutlet weak var previewBtn2: NavigationButton!
    @IBOutlet weak var nextBtn3: NavigationButton!
    @IBOutlet weak var pTask2Label: UILabel!
    @IBOutlet weak var pTaskBtn2: NavigationButton!
    @IBOutlet weak var recordBtn2: UIButton!
    @IBOutlet weak var doneBtn2: NavigationButton!
    
    @IBOutlet var preTask3View: UIView!
    @IBOutlet var pTask3View: UIView!
    @IBOutlet var task3View: UIView!
    @IBOutlet weak var task3ImageView: UIImageView!
    @IBOutlet weak var preTaskInstruction3: UILabel!
    @IBOutlet weak var previewBtn3: NavigationButton!
    @IBOutlet weak var nextBtn4: NavigationButton!
    @IBOutlet weak var pTask3Label: UILabel!
    @IBOutlet weak var pTask3Btn: NavigationButton!
    @IBOutlet weak var recordBtn3: UIButton!
    @IBOutlet weak var doneBtn3: NavigationButton!
    
    @IBOutlet var preTask4View: UIView!
    @IBOutlet var pTask4View: UIView!
    @IBOutlet var task4View: UIView!
    @IBOutlet weak var task4ImageView: UIImageView!
    @IBOutlet weak var specialText: UILabel!
    @IBOutlet weak var preTaskInstruction4: UILabel!
    @IBOutlet weak var previewBtn4: NavigationButton!
    @IBOutlet weak var nextBtn5: NavigationButton!
    @IBOutlet weak var pTask4Label: UILabel!
    @IBOutlet weak var pTask4Btn: NavigationButton!
    @IBOutlet weak var recordBtn4: UIButton!
    @IBOutlet weak var doneBtn4: NavigationButton!
    
    @IBOutlet weak var video1View: UIView!
    @IBOutlet weak var video2View: UIView!
    @IBOutlet weak var video3View: UIView!
    @IBOutlet weak var video4View: UIView!
    @IBOutlet var completeView: UIView!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var completeBtn: UIButton!

    @IBOutlet weak var practiceText: UILabel!
    
    var recordingSession: AVAudioSession!
    
    var soundRecorder: AVAudioRecorder!
    var playerController = AVPlayerViewController()
    var fileName : String = "testStroopAudioFile.m4a"
    var stimuli = [String: Any]()
    var images = Array<String>()
    var videos = Array<String>()
    var reactionTimes = [Int]()
    
    
    var myString = ""
    var myString2 = ""
    var myMutableString = NSMutableAttributedString()
    var myMutableString2 = NSMutableAttributedString()
    
    var startTime = TimeInterval()
    var timer = Timer()
    var isRunning = false
    var reactionTime = ""
    var position = 0
    var start: CFAbsoluteTime!
    
    var player = AVPlayer()
    
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
//        showOrientationAlert(orientation: "landscape")
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        
        // Insert row in database
        id = participant.string(forKey: "pid")!
        token = userDefaults.string(forKey: "token")!
        headers = [
            "x-access-token": token
        ]
        
        Alamofire.request(APIUrl + "api/stroop/new/" + id, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        }
        
        introView.translatesAutoresizingMaskIntoConstraints = false
        instructionsView.translatesAutoresizingMaskIntoConstraints = false
        preTask1View.translatesAutoresizingMaskIntoConstraints = false
        preTask2View.translatesAutoresizingMaskIntoConstraints = false
        preTask3View.translatesAutoresizingMaskIntoConstraints = false
        preTask4View.translatesAutoresizingMaskIntoConstraints = false
        pTask1View.translatesAutoresizingMaskIntoConstraints = false
        pTask2View.translatesAutoresizingMaskIntoConstraints = false
        pTask3View.translatesAutoresizingMaskIntoConstraints = false
        pTask4View.translatesAutoresizingMaskIntoConstraints = false
        task1View.translatesAutoresizingMaskIntoConstraints = false
        task2View.translatesAutoresizingMaskIntoConstraints = false
        task3View.translatesAutoresizingMaskIntoConstraints = false
        task4View.translatesAutoresizingMaskIntoConstraints = false
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
        
        // Grab images from the api
        self.images = DataManager.sharedInstance.stroopTasks
        self.videos = DataManager.sharedInstance.stroopVideos

        practiceText.text = "stroop_practice_instruction".localized(lang: language)
        
        practiceLabel.text = "Practice".localized(lang: language)
        practiceDoneBtn.setTitle("Done".localized(lang: language), for: .normal)
        loadingView.stopAnimating()
        recordBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        playBtn.setTitle("Play".localized(lang: language), for: .normal)
        playBtn.isEnabled = false
        previewBtn.setTitle("Preview".localized(lang: language), for: .normal)
        previewBtn2.setTitle("Preview".localized(lang: language), for: .normal)
        previewBtn3.setTitle("Preview".localized(lang: language), for: .normal)
        previewBtn4.setTitle("Preview".localized(lang: language), for: .normal)
        recordBtn1.setTitle("Start_Record".localized(lang: language), for: .normal)
        recordBtn2.setTitle("Start_Record".localized(lang: language), for: .normal)
        recordBtn3.setTitle("Start_Record".localized(lang: language), for: .normal)
        recordBtn4.setTitle("Start_Record".localized(lang: language), for: .normal)
        
        doneBtn.isHidden = true
        doneBtn2.isHidden = true
        doneBtn3.isHidden = true
        doneBtn4.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.landscape)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(.all)
    }
    
    func loadImageFromUrl(_ filename: String, view: UIImageView){
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(filename)
        view.image = UIImage(contentsOfFile: fileURL.path)
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
            finishRecording(button: button, success: false)
        }
    }
    
    func finishRecording(button: UIButton, success: Bool) {
        soundRecorder.stop()
        soundRecorder = nil
        
        button.isEnabled = false
        playBtn.isEnabled = true
    }
    
    func finishPlaying() {
        if (soundPlayer?.isPlaying)! {
            soundPlayer?.stop()
        }
        
        playBtn.setTitle("Play".localized(lang: language), for: .normal)
        recordBtn.isEnabled = true
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
        print("\(functionName): \(logMessage)")
    }
    
    func createPostObject(index: Int, reactionTime: Int) -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("stroop\(index).m4a")
            
        jsonObject = [
            "index": index as AnyObject,
            "reaction": reactionTime as AnyObject,
            "audio": fileURL as AnyObject
        ]

        
        return jsonObject
    }
    
    func postToAPI(object: [String: AnyObject]) {
        let index = object["index"] as! Int
        let reaction = object["reaction"] as! Int
        let fileURL = object["audio"] as! URL
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(fileURL, withName: "audio")
                multipartFormData.append(String(index).data(using: String.Encoding.utf8)!, withName: "index")
                multipartFormData.append(String(reaction).data(using: String.Encoding.utf8)!, withName: "reaction")
        }, usingThreshold: UInt64.init(),
           to: APIUrl + "api/stroop/uploadfile/" + id,
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
    
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        AppDelegate.position += 1
        AppDelegate.testPosition += 1
        self.navigationController?.pushViewController(TestOrder.sharedInstance.getTest(AppDelegate.testPosition), animated: true)
    }
    
    @IBAction func done(_ sender: AnyObject) {
        self.next(self)
    }
    
    // MARK: - Actions
    
    @IBAction func recordTapped(_ sender: UIButton) {
        if soundRecorder == nil {
            startRecording(sender, fileName: fileName)
        } else {
            finishRecording(button: sender, success: true)
        }
    }
    
    @IBAction func recordTask(_ sender: AnyObject) {
        if soundRecorder == nil {
            startRecording(sender as! UIButton, fileName: "stroop\(position).m4a")
        } else {
            finishRecording(button: sender as! UIButton, success: true)
            
            switch position {
            case 1:
                doneBtn.isHidden = false
            case 2:
                doneBtn2.isHidden = false
            case 3:
                doneBtn3.isHidden = false
            case 4:
                doneBtn4.isHidden = false
            default:
                return
            }
        }
    }
    
    @IBAction func playSound(_ sender: UIButton) {
        if sender.titleLabel!.text == "Play".localized(lang: language) {
            recordBtn.isEnabled = false
            sender.setTitle("Stop".localized(lang: language), for: UIControlState())
            preparePlayer()
            soundPlayer?.play()
        } else {
            soundPlayer?.stop()
            sender.setTitle("Play".localized(lang: language), for: UIControlState())
        }
    }

    @IBAction func moveToInstructions(_ sender: AnyObject) {
        setSubview(introView, next: instructionsView)
        practiceInstruction2.text = "stroop_practice_instruction2".localized(lang: language)
        stroopNextBtn.setTitle("Next".localized(lang: language), for: .normal)
    }
    
    @IBAction func moveToPreTask1(_ sender: AnyObject) {
        setSubview(instructionsView, next: preTask1View)
        preTaskInstruction.text = "stroop_pretask_instruction".localized(lang: language)
        previewBtn.setTitle("Preview".localized(lang: language), for: .normal)
        nextBtn2.setTitle("Next".localized(lang: language), for: .normal)
    }
    
    @IBAction func moveToPTask1(_ sender: AnyObject) {
        if player.rate != 0.0 {
            player.pause()
        }
        setSubview(preTask1View, next: pTask1View)
        pTaskLabel.text = "stroop_ptask".localized(lang: language)
        pTaskBtn.setTitle("Start".localized(lang: language), for: .normal)
    }
    
    @IBAction func moveToTask1(_ sender: AnyObject) {
        if self.player.rate != 0.0 {
            self.player.pause()
        }
        
        setSubview(pTask1View, next: task1View)
        self.task1ImageView.image = UIImage(named: images[position])
        doneBtn.setTitle("Done".localized(lang: language), for: .normal)
        position += 1
        start = CFAbsoluteTimeGetCurrent()
    }
    
    @IBAction func moveToPreTask2(_ sender: AnyObject) {
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        print(elapsed)
        let mill = elapsed * 1000
        postToAPI(object: createPostObject(index: 1, reactionTime: Int(mill)))
//        reactionTimes.insert(Int(mill), at: 0)
        setSubview(task1View, next: preTask2View)
        preTaskInstruction2.text = "stroop_pretask_instruction".localized(lang: language)
        previewBtn2.setTitle("Preview".localized(lang: language), for: .normal)
        nextBtn3.setTitle("Next".localized(lang: language), for: .normal)
    }
    
    @IBAction func moveToPTask2(_ sender: AnyObject) {
        if player.rate != 0.0 {
            player.pause()
        }
        setSubview(preTask2View, next: pTask2View)
        pTask2Label.text = "stroop_ptask".localized(lang: language)
        pTaskBtn2.setTitle("Start".localized(lang: language), for: .normal)
    }
    
    @IBAction func moveToTask2(_ sender: AnyObject) {
        if self.player.rate != 0.0 {
            self.player.pause()
        }
        setSubview(pTask2View, next: task2View)
        self.task2ImageView.image = UIImage(named: images[position])
        doneBtn2.setTitle("Done".localized(lang: language), for: .normal)
        position += 1
        start = CFAbsoluteTimeGetCurrent()
    }
    
    @IBAction func moveToPreTask3(_ sender: AnyObject) {
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        print(elapsed)
        let mill = elapsed * 1000
        postToAPI(object: createPostObject(index: 2, reactionTime: Int(mill)))
//        reactionTimes.insert(Int(mill), at: 1)
        setSubview(task2View, next: preTask3View)
        preTaskInstruction3.text = "stroop_pretask_instruction2".localized(lang: language)
        previewBtn3.setTitle("Preview".localized(lang: language), for: .normal)
        nextBtn4.setTitle("Next".localized(lang: language), for: .normal)
    }
    
    @IBAction func moveToPTask3(_ sender: AnyObject) {
        if player.rate != 0.0 {
            player.pause()
        }
        setSubview(preTask3View, next: pTask3View)
        pTask3Label.text = "stroop_ptask".localized(lang: language)
        pTask3Btn.setTitle("Start".localized(lang: language), for: .normal)
    }
    
    @IBAction func moveToTask3(_ sender: AnyObject) {
        setSubview(pTask3View, next: task3View)
        self.task3ImageView.image = UIImage(named: images[position])
        doneBtn3.setTitle("Done".localized(lang: language), for: .normal)
        position += 1
        start = CFAbsoluteTimeGetCurrent()
    }
    
    @IBAction func moveToPreTask4(_ sender: AnyObject) {
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        print(elapsed)
        let mill = elapsed * 1000
        postToAPI(object: createPostObject(index: 3, reactionTime: Int(mill)))
//        reactionTimes.insert(Int(mill), at: 2)
        setSubview(task3View, next: preTask4View)
        
        let myString = "stroop_pretask_instruction3".localized(lang: language)

        if let range = myString.range(of: "blue".localized(lang: language)) {
            let startPos = myString.characters.distance(from: myString.characters.startIndex, to: range.lowerBound)
            let endPos = myString.characters.distance(from: myString.characters.startIndex, to: range.upperBound)
            
            myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedStringKey.font:UIFont.init(name: "HelveticaNeue", size: 17.0)!])
            myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:startPos,length:endPos - startPos))
            preTaskInstruction4.attributedText = myMutableString
        }
        
        
        previewBtn4.setTitle("Preview".localized(lang: language), for: .normal)
        nextBtn5.setTitle("Next".localized(lang: language), for: .normal)
    }
    
    @IBAction func moveToPTask4(_ sender: AnyObject) {
        if player.rate != 0.0 {
            player.pause()
        }
        setSubview(preTask4View, next: pTask4View)
        pTask4Label.text = "stroop_ptask".localized(lang: language)
        pTask4Btn.setTitle("Start".localized(lang: language), for: .normal)
    }
    
    @IBAction func moveToTask4(_ sender: AnyObject) {
        if self.player.rate != 0.0 {
            self.player.pause()
        }
        setSubview(pTask4View, next: task4View)
        self.task4ImageView.image = UIImage(named: images[1])
        doneBtn4.setTitle("Done".localized(lang: language), for: .normal)
        position += 1
        start = CFAbsoluteTimeGetCurrent()
    }
    
    @IBAction func submitTask(_ sender: AnyObject) {
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        print(elapsed)
        let mill = elapsed * 1000
        postToAPI(object: createPostObject(index: 4, reactionTime: Int(mill)))
//        reactionTimes.insert(Int(mill), at: 3)
        
        if self.player.rate != 0.0 {
            self.player.pause()
        }
        
        setSubview(task4View, next: self.completeView)
        completeLabel.text = "Test_complete".localized(lang: language)
        completeBtn.setTitle("Submit".localized(lang: language), for: .normal)
    }
    
    @IBAction func playVideo(_ sender: AnyObject) {
        playVideoFile(filename: videos[sender.tag], index: sender.tag)
    }
    
    func playVideoFile(filename: String, index: Int) {
        guard let path = Bundle.main.path(forResource: filename, ofType: nil) else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        player = AVPlayer(url: url)
        player.actionAtItemEnd = .none
        
        playerController.delegate = self
        playerController.player = player
        let videoLayer = AVPlayerLayer(player: player)
        
        if index == 0 {
            videoLayer.frame = video1View.bounds
            video1View.layer.addSublayer(videoLayer)
        } else if index == 1 {
            videoLayer.frame = video2View.bounds
            video2View.layer.addSublayer(videoLayer)
        } else if index == 2 {
            videoLayer.frame = video3View.bounds
            video3View.layer.addSublayer(videoLayer)
        } else if index == 3 {
            videoLayer.frame = video4View.bounds
            video4View.layer.addSublayer(videoLayer)
        }
        player.play()
    }
    
    
    
    // MARK: - Delegate

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NSLog("finished playing")
        finishPlaying()
    }
    
    func playerDidFinishPlaying(note: NSNotification){
        print("Video Finished")
        self.dismiss(animated: true, completion: nil)
        print(position)
        switch position {
            case 0: moveToTask1(self)
            case 1: moveToTask2(self)
            case 2: moveToTask3(self)
            case 3: moveToTask4(self)
            default: moveToTask1(self)
        }
    }
    
    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        NSLog("video stopped")
    }
}
