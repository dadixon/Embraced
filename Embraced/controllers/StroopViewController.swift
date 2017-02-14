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
    var fileName : String = "testAudioFile.m4a"
    var stimuli = [String: Any]()
    var images = Array<String>()
    var videos = Array<String>()
    
    
    
    var myString = ""
    var myString2 = ""
    var myMutableString = NSMutableAttributedString()
    var myMutableString2 = NSMutableAttributedString()
    
    var startTime = TimeInterval()
    var timer = Timer()
    var isRunning = false
    var reactionTime = ""
    var position = 0
    
    var player = AVPlayer()
    
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
        
        orientation = "landscape"
        rotated()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(StroopViewController.next(_:)))
        
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
        images = DataManager.sharedInstance.stroopImages
        videos = DataManager.sharedInstance.stroopVideos
        print(images)
        

        let myString = "stroop_practice_instruction".localized(lang: participant.string(forKey: "language")!)
        
        myMutableString = NSMutableAttributedString(string: myString, attributes: [NSFontAttributeName:UIFont.init(name: "HelveticaNeue", size: 17.0)!])
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(location:51,length:5))
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(location:61,length:4))
        practiceText.attributedText = myMutableString
        
        practiceLabel.text = "Practice".localized(lang: participant.string(forKey: "language")!)
        practiceDoneBtn.setTitle("Done".localized(lang: participant.string(forKey: "language")!), for: .normal)
        loadingView.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImageFromUrl(_ filename: String, view: UIImageView){
        view.image = UIImage(named: filename)
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
            
            button.setTitle("Stop".localized(lang: participant.string(forKey: "language")!), for: .normal)
            startTimer()
        } catch {
            finishRecording(button: button, success: false)
        }
    }
    
    func finishRecording(button: UIButton, success: Bool) {
        soundRecorder.stop()
        soundRecorder = nil
        
        if success {
            button.setTitle("Re-record".localized(lang: participant.string(forKey: "language")!), for: .normal)
        } else {
            button.setTitle("Record".localized(lang: participant.string(forKey: "language")!), for: .normal)
            // recording failed :(
        }
        
        stopTime()
        resetTimer()
        startTimer()
    }
    
    func finishPlaying() {
        if (soundPlayer?.isPlaying)! {
            soundPlayer?.stop()
        }
        
        playBtn.setTitle("Play".localized(lang: participant.string(forKey: "language")!), for: .normal)
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
    
    func stopTime() {
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        var elapsedTime : TimeInterval = currentTime - startTime
        
        //calculate the seconds in elapsed time
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)

        let strSeconds = seconds > 9 ? String(seconds): "0" + String(seconds)
        
        reactionTime = "\(strSeconds)"
        
        print(reactionTime)
        
    }
    
    func startTimer() {
        if !timer.isValid {
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    func resetTimer() {
        timer.invalidate()
    }
    
    func log(logMessage: String, functionName: String = #function) {
        print("\(functionName): \(logMessage)")
    }
    
    func createPostObject() -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        var jsonTask = [AnyObject]()
        var jsonTaskObject = [String: AnyObject]()
        
        for i in 1...position {
            let soundData = FileManager.default.contents(atPath: getCacheDirectory().stringByAppendingPathComponent("stroop\(i).m4a"))
            let dataStr = soundData?.base64EncodedString(options: [])
            
            jsonTaskObject = [
                "name": "stroop\(i)" as AnyObject,
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
    
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        AppDelegate.position += 1
        nextViewController2(position: AppDelegate.position)
    }
    
    @IBAction func done(_ sender: AnyObject) {
        let jsonObject = createPostObject()
        
        if (jsonObject.count > 0) {
            APIWrapper.post(id: participant.string(forKey: "pid")!, test: "stroop", data: jsonObject)
        }
        
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
        }
    }
    
    @IBAction func playSound(_ sender: UIButton) {
        if sender.titleLabel!.text == "Play".localized(lang: participant.string(forKey: "language")!) {
            recordBtn.isEnabled = false
            sender.setTitle("Stop".localized(lang: participant.string(forKey: "language")!), for: UIControlState())
            preparePlayer()
            soundPlayer?.play()
        } else {
            soundPlayer?.stop()
            sender.setTitle("Play".localized(lang: participant.string(forKey: "language")!), for: UIControlState())
        }
    }

    @IBAction func moveToInstructions(_ sender: AnyObject) {
        setSubview(introView, next: instructionsView)
        practiceInstruction2.text = "stroop_practice_instruction2".localized(lang: participant.string(forKey: "language")!)
        stroopNextBtn.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
    }
    
    @IBAction func moveToPreTask1(_ sender: AnyObject) {
        setSubview(instructionsView, next: preTask1View)
        preTaskInstruction.text = "stroop_pretask_instruction".localized(lang: participant.string(forKey: "language")!)
        previewBtn.setTitle("Preview".localized(lang: participant.string(forKey: "language")!), for: .normal)
        nextBtn2.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
    }
    
    @IBAction func moveToPTask1(_ sender: AnyObject) {
        setSubview(preTask1View, next: pTask1View)
        pTaskLabel.text = "stroop_ptask".localized(lang: participant.string(forKey: "language")!)
        pTaskBtn.setTitle("Start".localized(lang: participant.string(forKey: "language")!), for: .normal)
    }
    
    @IBAction func moveToTask1(_ sender: AnyObject) {
        player.pause()
        setSubview(pTask1View, next: task1View)
        self.loadImageFromUrl(images[position], view: self.task1ImageView)
        doneBtn.setTitle("Done".localized(lang: participant.string(forKey: "language")!), for: .normal)
        position += 1
    }
    
    @IBAction func moveToPreTask2(_ sender: AnyObject) {
        setSubview(task1View, next: preTask2View)
        preTaskInstruction2.text = "stroop_pretask_instruction".localized(lang: participant.string(forKey: "language")!)
        previewBtn2.setTitle("Preview".localized(lang: participant.string(forKey: "language")!), for: .normal)
        nextBtn3.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
    }
    
    @IBAction func moveToPTask2(_ sender: AnyObject) {
        setSubview(preTask2View, next: pTask2View)
        pTask2Label.text = "stroop_ptask".localized(lang: participant.string(forKey: "language")!)
        pTaskBtn2.setTitle("Start".localized(lang: participant.string(forKey: "language")!), for: .normal)
    }
    
    @IBAction func moveToTask2(_ sender: AnyObject) {
        player.pause()
        setSubview(pTask2View, next: task2View)
        self.loadImageFromUrl(images[position], view: self.task2ImageView)
        doneBtn2.setTitle("Done".localized(lang: participant.string(forKey: "language")!), for: .normal)
        position += 1
    }
    
    @IBAction func moveToPreTask3(_ sender: AnyObject) {
        setSubview(task2View, next: preTask3View)
        preTaskInstruction3.text = "stroop_pretask_instruction2".localized(lang: participant.string(forKey: "language")!)
        previewBtn3.setTitle("Preview".localized(lang: participant.string(forKey: "language")!), for: .normal)
        nextBtn4.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
    }
    
    @IBAction func moveToPTask3(_ sender: AnyObject) {
        setSubview(preTask3View, next: pTask3View)
        pTask3Label.text = "stroop_ptask".localized(lang: participant.string(forKey: "language")!)
        pTask3Btn.setTitle("Start".localized(lang: participant.string(forKey: "language")!), for: .normal)
    }
    
    @IBAction func moveToTask3(_ sender: AnyObject) {
        player.pause()
        setSubview(pTask3View, next: task3View)
        self.loadImageFromUrl(images[position], view: self.task3ImageView)
        doneBtn3.setTitle("Done".localized(lang: participant.string(forKey: "language")!), for: .normal)
        position += 1
    }
    
    @IBAction func moveToPreTask4(_ sender: AnyObject) {
        setSubview(task3View, next: preTask4View)
        
        myMutableString = NSMutableAttributedString(string: myString, attributes: [NSFontAttributeName:UIFont.init(name: "HelveticaNeue", size: 17.0)!])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:28,length:4))
        specialText.attributedText = myMutableString
        preTaskInstruction4.text = "stroop_pretask_instruction3".localized(lang: participant.string(forKey: "language")!)
        previewBtn4.setTitle("Preview".localized(lang: participant.string(forKey: "language")!), for: .normal)
        nextBtn5.setTitle("Next".localized(lang: participant.string(forKey: "language")!), for: .normal)
    }
    
    @IBAction func moveToPTask4(_ sender: AnyObject) {
        setSubview(preTask4View, next: pTask4View)
        pTask4Label.text = "stroop_ptask".localized(lang: participant.string(forKey: "language")!)
        pTask4Btn.setTitle("Start".localized(lang: participant.string(forKey: "language")!), for: .normal)
    }
    
    @IBAction func moveToTask4(_ sender: AnyObject) {
        player.pause()
        setSubview(pTask4View, next: task4View)
        self.loadImageFromUrl(images[1], view: self.task4ImageView)
        doneBtn4.setTitle("Done".localized(lang: participant.string(forKey: "language")!), for: .normal)
        position += 1
    }
    
    @IBAction func submitTask(_ sender: AnyObject) {
        player.pause()
        
        setSubview(task4View, next: self.completeView)
        completeLabel.text = "Test_complete".localized(lang: participant.string(forKey: "language")!)
        completeBtn.setTitle("Submit".localized(lang: participant.string(forKey: "language")!), for: .normal)
    }
    
    @IBAction func playVideo(_ sender: AnyObject) {
//        let fileURL = NSURL(string: videos[sender.tag])!
        playVideoFile(filename: videos[sender.tag], index: sender.tag)
    }
    
    func playVideoFile(filename: String, index: Int) {
        let path = Bundle.main.path(forResource: filename, ofType: nil)
        let url = URL(fileURLWithPath: path!)
        
        player = AVPlayer(url: url as URL)
        
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
