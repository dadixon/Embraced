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

class StroopViewController: FrontViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, AVPlayerViewControllerDelegate {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var introView: UIView!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet var instructionsView: UIView!
    
    @IBOutlet var preTask1View: UIView!
    @IBOutlet var task1View: UIView!
    @IBOutlet weak var task1ImageView: UIImageView!
    
    @IBOutlet var preTask2View: UIView!
    @IBOutlet var task2View: UIView!
    @IBOutlet weak var task2ImageView: UIImageView!
    
    @IBOutlet var preTask3View: UIView!
    @IBOutlet var task3View: UIView!
    @IBOutlet weak var task3ImageView: UIImageView!
    
    @IBOutlet var preTask4View: UIView!
    @IBOutlet var task4View: UIView!
    @IBOutlet weak var task4ImageView: UIImageView!
    @IBOutlet weak var specialText: UILabel!
    
    @IBOutlet weak var video1View: UIView!
    @IBOutlet weak var video2View: UIView!
    @IBOutlet weak var video3View: UIView!
    @IBOutlet weak var video4View: UIView!

    @IBOutlet weak var practiceText: UILabel!
    
    var recordingSession: AVAudioSession!
    
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    var playerController = AVPlayerViewController()
    var fileName : [String] = ["testAudioFile.m4a", "task1.m4a", "task2.m4a", "task3.m4a", "task4.m4a"]
    
    var stimuli = [String: Any]()
    var images = Array<String>()
    var videos = Array<String>()
    
    
    
    let myString: String = "For example, for the word: “blue”, which is written in red, you have to say “red”."
    let myString2: String = "Please practice how to record your voice using the Start and Play buttons below. \nClick done when you are finished."
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
        step = 15
        super.viewDidLoad()
        
        orientation = "landscape"
        rotated()
        
        
//        self.present(alertController!, animated: true, completion: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(StroopViewController.next(_:)))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(StroopViewController.back(_:)))
        
        introView.translatesAutoresizingMaskIntoConstraints = false
        instructionsView.translatesAutoresizingMaskIntoConstraints = false
        preTask1View.translatesAutoresizingMaskIntoConstraints = false
        preTask2View.translatesAutoresizingMaskIntoConstraints = false
        preTask3View.translatesAutoresizingMaskIntoConstraints = false
        preTask4View.translatesAutoresizingMaskIntoConstraints = false
        task1View.translatesAutoresizingMaskIntoConstraints = false
        task2View.translatesAutoresizingMaskIntoConstraints = false
        task3View.translatesAutoresizingMaskIntoConstraints = false
        task4View.translatesAutoresizingMaskIntoConstraints = false
        
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
        images = appDelegate.stroopStimuli["images"] as! Array<String>
        videos = appDelegate.stroopStimuli["videos"] as! Array<String>
        
        myMutableString2 = NSMutableAttributedString(string: myString2, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 17.0)!])
        myMutableString2.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(location:51,length:5))
        myMutableString2.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(location:61,length:4))
        practiceText.attributedText = myMutableString2
        
        loadingView.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImageFromUrl(_ url: String, view: UIImageView){
        
        // Create Url from string
        let url = URL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        })
        
        // Run task
        task.resume()
    }
    
    func startRecording(_ button: UIButton) {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName[button.tag])
        
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
            startTimer()
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
        
        stopTime()
        resetTimer()
        startTimer()
    }
    
    func finishPlaying() {
        soundPlayer.stop()
        soundPlayer = nil
        
        playBtn.setTitle("Play", for: .normal)
        recordBtn.isEnabled = true
    }
    
    func preparePlayer() {
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: getDocumentsDirectory().appendingPathComponent(fileName[0]))
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
    
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
//        var navigationArray = self.navigationController?.viewControllers
//        
//        navigationArray?.remove(at: 0)
        
        let digitalSpanViewController:CancellationTestViewController = CancellationTestViewController()
//        navigationArray?.append(digitalSpanViewController)
//        
//        self.navigationController?.setViewControllers(navigationArray!, animated: true)
        self.navigationController?.pushViewController(digitalSpanViewController, animated: true)
    }
    
//    @IBAction func back(_ sender: AnyObject) {
//        _ = self.navigationController?.popViewController(animated: true)
//    }
    
    
    // MARK: - Actions
    
    @IBAction func recordTapped(_ sender: UIButton) {
        if soundRecorder == nil {
            startRecording(sender)
        } else {
            finishRecording(button: sender, success: true)
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

    @IBAction func moveToInstructions(_ sender: AnyObject) {
        setSubview(introView, next: instructionsView)
    }
    
    @IBAction func moveToPreTask1(_ sender: AnyObject) {
        setSubview(instructionsView, next: preTask1View)
    }
    
    @IBAction func moveToTask1(_ sender: AnyObject) {
        player.pause()
        setSubview(preTask1View, next: task1View)
        self.loadImageFromUrl(images[position], view: self.task1ImageView)
        position += 1
    }
    
    @IBAction func moveToPreTask2(_ sender: AnyObject) {
        setSubview(task1View, next: preTask2View)
    }
    
    @IBAction func moveToTask2(_ sender: AnyObject) {
        player.pause()
        setSubview(preTask2View, next: task2View)
        self.loadImageFromUrl(images[position], view: self.task2ImageView)
        position += 1
    }
    
    @IBAction func moveToPreTask3(_ sender: AnyObject) {
        setSubview(task2View, next: preTask3View)
    }
    
    @IBAction func moveToTask3(_ sender: AnyObject) {
        player.pause()
        setSubview(preTask3View, next: task3View)
        self.loadImageFromUrl(images[position], view: self.task3ImageView)
        position += 1
    }
    
    @IBAction func moveToPreTask4(_ sender: AnyObject) {
        setSubview(task3View, next: preTask4View)
        
        myMutableString = NSMutableAttributedString(string: myString, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 17.0)!])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:28,length:4))
        specialText.attributedText = myMutableString
    }
    
    @IBAction func moveToTask4(_ sender: AnyObject) {
        player.pause()
        setSubview(preTask4View, next: task4View)
        self.loadImageFromUrl(images[1], view: self.task4ImageView)
        position += 1
    }
    
    @IBAction func playVideo(_ sender: AnyObject) {
        let fileURL = NSURL(string: videos[sender.tag])!
        playVideoFile(url: fileURL, index: sender.tag)
    }
    
    func playVideoFile(url: NSURL, index: Int){
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
