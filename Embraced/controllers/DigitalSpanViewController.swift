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
    
    @IBOutlet var preTask1View: UIView!
    @IBOutlet var task1View: UIView!
    @IBOutlet var preTask2View: UIView!
    @IBOutlet var task2View: UIView!
    
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(DigitalSpanViewController.back(_:)))
        
        introView.translatesAutoresizingMaskIntoConstraints = false
        preTask1View.translatesAutoresizingMaskIntoConstraints = false
        preTask2View.translatesAutoresizingMaskIntoConstraints = false
        task1View.translatesAutoresizingMaskIntoConstraints = false
        task2View.translatesAutoresizingMaskIntoConstraints = false
        
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

        forward = appDelegate.digitalSpanStimuli["forward"] as! Array<String>
        backward = appDelegate.digitalSpanStimuli["backward"] as! Array<String>
        
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
    
    func play(_ url:NSURL) {
        print("playing \(url)")
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url as URL)
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
    
    func downloadFileFromURL(url:NSURL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { (URL, response, error) -> Void in
            self.play(URL! as NSURL)
        })
        
        downloadTask.resume()
    }
    
    func log(logMessage: String, functionName: String = #function) {
        print("\(functionName): \(logMessage)")
    }
    
    
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
//        var navigationArray = self.navigationController?.viewControllers
//        
//        navigationArray?.remove(at: 0)
        
        let reyComplexFigure3ViewController:ReyComplexFigure3ViewController = ReyComplexFigure3ViewController()
//        navigationArray?.append(reyComplexFigure3ViewController)
//        
//        self.navigationController?.setViewControllers(navigationArray!, animated: true)
        self.navigationController?.pushViewController(reyComplexFigure3ViewController, animated: true)
    }
    
    @IBAction func back(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
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
            startRecording(sender as! UIButton, fileName: "forward\(forwardCount)")
        } else {
            finishRecording(sender as! UIButton, success: true)
        }
    }
    
    @IBAction func recordBackward(_ sender: AnyObject) {
        if soundRecorder == nil {
            startRecording(sender as! UIButton, fileName: "backward\(backwardCount)")
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
    
    @IBAction func listenToSound(_ sender: AnyObject) {
        if sender.tag == 0 {
            let url = NSURL(string: forward[forward.count - 1])
            downloadFileFromURL(url: url!)
        } else if sender.tag == 1 {
            let url = NSURL(string: forward[forwardCount])
            downloadFileFromURL(url: url!)
        } else if sender.tag == 2 {
            let url = NSURL(string: backward[backward.count - 1])
            downloadFileFromURL(url: url!)
        } else if sender.tag == 3 {
            let url = NSURL(string: backward[backwardCount])
            downloadFileFromURL(url: url!)
        }
    }
    
    @IBAction func moveToListen(_ sender: AnyObject) {
        setSubview(introView, next: preTask1View)
    }
    
    @IBAction func moveToForward(_ sender: AnyObject) {
        setSubview(preTask1View, next: task1View)
    }
    
    @IBAction func nextSound(_ sender: AnyObject) {
        instructionsA.text = "Click on LISTEN button when you are ready."
        if (forwardCount < forward.count - 2) {
            forwardCount += 1
            rounds.text = "Round \(forwardCount+1)"
        } else {
            setSubview(task1View, next: preTask2View)
        }
    }
    
    @IBAction func moveToBackward(_ sender: AnyObject) {
        setSubview(preTask2View, next: task2View)
        bRounds.text = "Round \(backwardCount+1)"
    }
    
    @IBAction func nextBSound(_ sender: AnyObject) {
        instructions.text = "Click on LISTEN button when you are ready."
        if (backwardCount < backward.count - 2) {
            backwardCount += 1
            bRounds.text = "Round \(backwardCount+1)"
        } else {
            setSubview(task1View, next: preTask2View)
        }
    }
    
    // MARK: - Delegate
    
//    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        playBtn.isEnabled = true
//    }
//    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBtn.isEnabled = true
        playBtn.setTitle("Play", for: UIControlState())
    }
}
