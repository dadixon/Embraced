//
//  WordListViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class WordListViewController: FrontViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet var practiceView: UIView!
    @IBOutlet var trial1View: UIView!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var trialRecordBtn: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var InstructionsLabel: UILabel!
    
    
    var recordingSession: AVAudioSession!
    
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    var fileName : [String] = ["testAudioFile.m4a", "trial1.m4a", "trial2.m4a", "trial3.m4a", "trial4.m4a", "trial5.m4a"]
    
    var startTime = TimeInterval()
    var timer = Timer()
    var count = 3
    var stimuli = [String: Any]()
    var trials = Array<String>()
    var sound = String()
    var practice = true
    var position = 0
    var instructions : [String] = ["There will be a 3 second countdown before the list starts. \nPlease tap the LISTEN button when you are ready to start",
                                   "Now say out loud all the words you can remember from the list. \nTap the microphone button to start recording",
                                   "Now say out loud all the words you can remember from the list, including the ones you said before. \nTap the microphone button to start recording",
                                   "Now say out loud all the words you can remember from the list, including the ones you said before. \nTap the microphone button to start recording",
                                   "Now say out loud all the words you can remember from the list, including the ones you said before. \nTap the microphone button to start recording",
                                   "Now say out loud all the words you can remember from the list, including the ones you said before. \nTap the microphone button to start recording"]
    
    
    
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
        step = 14
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(WordListViewController.next(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(WordListViewController.back(_:)))
        
        orientation = "landscape"
        rotated()
        
        practiceView.translatesAutoresizingMaskIntoConstraints = false
        trial1View.translatesAutoresizingMaskIntoConstraints = false
        
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
        let requestURL: URL = URL(string: "http://api.girlscouts.harryatwal.com/wordlist")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do {
                    self.stimuli = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:Any]
                    self.trials = self.stimuli["trials"] as! Array<String>
                    print("\(self.trials[0])")
                } catch {
                    print("Error with Json: \(error)")
                }
            }
        })
        
        task.resume()
        
        loadingView.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        titleLabel.text = "Trial \(position + 1)"
        InstructionsLabel.text = instructions[position]
        trialRecordBtn.isEnabled = false
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
    
    func finishPlaying() {
        soundPlayer.stop()
        soundPlayer = nil
        
        if practice {
            playBtn.setTitle("Play", for: .normal)
            recordBtn.isEnabled = true
        } else {
            trialRecordBtn.isEnabled = true
        }
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
    
    func update() {
        if(count > 0) {
            countLabel.text = String(count)
            count -= 1
        } else {
            timer.invalidate()
            countLabel.text = ""
            
            let url = NSURL(string: "http://api.girlscouts.harryatwal.com/static_audios/word_list/english/trials/List_A_ENG.mp3")
            preparePlayer()
            downloadFileFromURL(url: url!)
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
//        var navigationArray = self.navigationController?.viewControllers
//        
//        navigationArray?.remove(at: 0)
        
        let mOCAMMSETestViewController:PegboardViewController = PegboardViewController()
//        navigationArray?.append(mOCAMMSETestViewController)
//        
//        self.navigationController?.setViewControllers(navigationArray!, animated: true)
        self.navigationController?.pushViewController(mOCAMMSETestViewController, animated: true)
    }

    @IBAction func back(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moveToTrial1(_ sender: AnyObject) {
        setSubview(practiceView, next: trial1View)
        setup()
        practice = false
    }
    
    
    // MARK: - Action
    
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
    
    @IBAction func listen(_ sender: AnyObject) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
    }
    
    @IBAction func nextTrial(_ sender: AnyObject) {
        position += 1
        
        if position < instructions.count {
            setup()
        } else {
            next(self)
        }
    }
    
    
    
    // MARK: - Delegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NSLog("finished playing")
        finishPlaying()
    }
}
