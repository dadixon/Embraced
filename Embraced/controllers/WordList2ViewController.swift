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

class WordList2ViewController: FrontViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet var practiceView: UIView!
    @IBOutlet var recognitionView: UIView!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var firstListLabel: UILabel!
    @IBOutlet weak var listenBtn: UIButton!
    @IBOutlet weak var answerSegment: UISegmentedControl!
    
    var recordingSession: AVAudioSession!
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    var fileName : String = "testAudioFile.m4a"
    var tasks = Array<String>()
    var startTime = TimeInterval()
    var timer = Timer()
    var count = 3
    var position = 0
    var answers = [String]()
    var answer = String()
    
    
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(WordListViewController.next(_:)))
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(WordListViewController.back(_:)))
        
        
        practiceView.translatesAutoresizingMaskIntoConstraints = false
        recognitionView.translatesAutoresizingMaskIntoConstraints = false
        
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
        tasks = appDelegate.wordlistStimuli["tasks"] as! Array<String>
        
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
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func finishRecording(button: UIButton, success: Bool) {
        soundRecorder.stop()
        soundRecorder = nil
        
        if success {
            button.setTitle("Re-record", for: .normal)
        } else {
            button.setTitle("Record", for: .normal)
            // recording failed :(
        }
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
            
            let url = NSURL(string: tasks[position])!
            
            downloadFileFromURL(url: url)
        }
    }
    
    func resetTimer() {
        timer.invalidate()
    }
    
    func downloadFileFromURL(url:NSURL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { (URL, response, error) -> Void in
            self.play(URL! as NSURL)
        })
        
        downloadTask.resume()
        
    }
    
    func play(_ url:NSURL) {
        print("playing \(url)")
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url as URL)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
            soundPlayer.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
    
    func finishPlaying() {
        soundPlayer.stop()
        soundPlayer = nil
        
        firstListLabel.isHidden = false
        answerSegment.isHidden = false
        listenBtn.isEnabled = false
    }
    
    
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        var navigationArray = self.navigationController?.viewControllers
        
        navigationArray?.remove(at: 0)
        
        let mOCAMMSETestViewController:NamingTaskViewController = NamingTaskViewController()
        navigationArray?.append(mOCAMMSETestViewController)
        
        self.navigationController?.setViewControllers(navigationArray!, animated: true)
        //        self.navigationController?.pushViewController(mOCAMMSETestViewController, animated: true)
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
        count = 3
        startTimer()
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
            next(self)
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
