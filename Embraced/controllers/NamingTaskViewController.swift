//
//  NamingTaskViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import Stormpath

class NamingTaskViewController: FrontViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timerCount: UILabel!
    @IBOutlet weak var taskImageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var initialView: UIView!
    @IBOutlet var trialView: UIView!
    @IBOutlet var preTaskView: UIView!
    @IBOutlet var taskView: UIView!

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    var fileName = "audioFile.m4a"
    
    var practice = Array<String>()
    var task = Array<String>()
    var count = 0
    var timeCount = 5
    
    let skipBtnDelay = 5.0 * Double(NSEC_PER_SEC)
    
    var startTime = TimeInterval()
    var timer = Timer()
    var isRunning = false
    var isTask = false
    
    
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
        step = 18
        
        super.viewDidLoad()

        practice = appDelegate.namingTaskPractice
        task = appDelegate.namingTaskTask
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(NamingTaskViewController.next(_:)))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(ReyComplexFigureViewController.back(_:)))
        
        orientation = "landscape"
        rotated()
        
        initialView.translatesAutoresizingMaskIntoConstraints = false
        trialView.translatesAutoresizingMaskIntoConstraints = false
        preTaskView.translatesAutoresizingMaskIntoConstraints = false
        taskView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(initialView)
        
        let leftConstraint = initialView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let topConstraint = initialView.topAnchor.constraint(equalTo: containerView.topAnchor)
        let rightConstraint = initialView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottomConstraint = initialView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
        
        recordingSession = AVAudioSession.sharedInstance()
        
        loadingView.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImageFromUrl(_ filename: String, view: UIImageView) {
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
            
            button.setTitle("Stop", for: .normal)
        } catch {
            finishRecording(button, success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        return paths[0]
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
    
//    func play(_ url:NSURL) {
//        print("playing \(url)")
//        
//        do {
//            soundPlayer = try AVAudioPlayer(contentsOf: url as URL)
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
    
    func log(logMessage: String, functionName: String = #function) {
        print("\(functionName): \(logMessage)")
    }
    
    func updateTime() {
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        var elapsedTime : TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        
        //fraction of milliseconds
        
//        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutues, seconds and milliseconds, store
        // as string constants
//        
//        let strMinutes = minutes > 9 ? String(minutes): "0" + String(minutes)
//        
//        let strSeconds = seconds > 9 ? String(seconds): "0" + String(seconds)
//        
//        let strFraction = fraction > 9 ? String(fraction): "0" + String(fraction)
        
        //concatonate mins, seoncds and milliseconds, assign to UILable timercount
        
//        timerCount.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
        if seconds >= 15 {
            timerCount.text = String(timeCount)
            
            if timeCount == 0 {
                nextTask(self)
                resetTimer()
                startTimer()
                timeCount = 5
                timerCount.text = ""
            } else {
                timeCount -= 1
            }
        }
        
    }
    
    func startTimer() {
        if !timer.isValid {
            
            let aSelector : Selector = #selector(NamingTaskViewController.updateTime)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
            
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    func resetTimer() {
        timer.invalidate()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playBtn.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBtn.isEnabled = true
        playBtn.setTitle("Play", for: UIControlState())
        playBtn.isEnabled = false
    }
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
//        var navigationArray = self.navigationController?.viewControllers
//        
//        navigationArray?.remove(at: 0)
        
        let multipleErrandsViewController:ComprehensionViewController = ComprehensionViewController()
//        navigationArray?.append(multipleErrandsViewController)
//        
//        self.navigationController?.setViewControllers(navigationArray!, animated: true)
        self.navigationController?.pushViewController(multipleErrandsViewController, animated: true)
    }
    
//    @IBAction func back(_ sender: AnyObject) {
//        _ = self.navigationController?.popViewController(animated: true)
//    }
    
    
    // MARK: - Actions
    @IBAction func recordTapped(_ sender: UIButton) {
        if soundRecorder == nil {
            startRecording(sender, fileName: fileName)
        } else {
            finishRecording(sender, success: true)
        }
    }
    
    @IBAction func recordTask(_ sender: AnyObject) {
        if soundRecorder == nil {
            startRecording(sender as! UIButton, fileName: "namingTask\(count).m4a")
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
            soundPlayer.stop()
            sender.setTitle("Play", for: UIControlState())
        }
    }
    
    @IBAction func initialToTrial(_ sender: AnyObject) {
        setSubview(initialView, next: trialView)
        loadImageFromUrl(practice[count], view: imageView)
    }
    
    @IBAction func nextExample(_ sender: AnyObject) {
        count += 1
        if count < practice.count {
            loadImageFromUrl(practice[count], view: imageView)
        } else {
            setSubview(trialView, next: preTaskView)
        }
    }
    
    @IBAction func toTask(_ sender: AnyObject) {
        isTask = true
        setSubview(preTaskView, next: taskView)
        count = 0
        loadImageFromUrl(task[count], view: taskImageView)
        startTimer()
    }
    
    @IBAction func nextTask(_ sender: AnyObject) {
        count += 1
        
        if count < task.count {
            loadImageFromUrl(task[count], view: taskImageView)
            resetTimer()
            startTimer()
        } else {
            resetTimer()
            APIWrapper.post(id: participant.string(forKey: "pid")!, test: "naming_task", data: createPostObject())
//            let multipleErrandsViewController:ComprehensionViewController = ComprehensionViewController()
//            self.navigationController?.pushViewController(multipleErrandsViewController, animated: true)
        }
    }
    
    func createPostObject() -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        var jsonTask = [AnyObject]()
        var jsonTaskObject = [String: AnyObject]()
        
        for i in 0...count {
            let soundData = FileManager.default.contents(atPath: getCacheDirectory().stringByAppendingPathComponent("namingTask\(i).m4a"))
            let dataStr = soundData?.base64EncodedString(options: [])
            
            jsonTaskObject = [
                "name": "task\(i+1)" as AnyObject,
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
}

extension String {
    func stringByAppendingPathComponent(_ pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
}
