//
//  NamingTaskViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation

class NamingTaskViewController: FrontViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timerCount: UILabel!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    var fileName = "audioFile.m4a"
    
    var stimuli : [String] = []
    var count = 0
    
    let skipBtnDelay = 5.0 * Double(NSEC_PER_SEC)
    
    var startTime = TimeInterval()
    var timer = Timer()
    var isRunning = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRecorder()
        
        let requestURL: URL = URL(string: "http://api.girlscouts.harryatwal.com/name_task")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do {
                    self.stimuli = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String]
                    self.loadImageFromUrl(self.stimuli[0], view: self.imageView)
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }) 
        
        task.resume()
        
        startTimer()
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
    
    func setupRecorder() {
        let recordSettings : [String:AnyObject] = [AVFormatIDKey: NSNumber(value: Int32(kAudioFormatAppleLossless) as Int32),
                              AVEncoderAudioQualityKey: NSNumber(value: Int32(AVAudioQuality.max.rawValue) as Int32),
                              AVEncoderBitRateKey: NSNumber(value: Int32(320000) as Int32),
                              AVNumberOfChannelsKey: NSNumber(value: 2 as Int32),
                              AVSampleRateKey: NSNumber(value: Float(44100.0) as Float)]
        
        do {
            soundRecorder = try AVAudioRecorder(url: getFileURL(), settings: recordSettings)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            NSLog("Something went wrong")
        }
        
    }

    func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) 
        
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getCacheDirectory().stringByAppendingPathComponent(fileName)
        let filePath = URL(fileURLWithPath: path)
        
        return filePath
    }
    
    @IBAction func record(_ sender: UIButton) {
        if sender.titleLabel!.text == "Record" {
            soundRecorder.record()
            sender.setTitle("Stop", for: UIControlState())
            playBtn.isEnabled = false
        } else {
            soundRecorder.stop()
            sender.setTitle("Record", for: UIControlState())
            playBtn.isEnabled = false
            resetTimer()
            startTimer()
            
            count += 1
            loadImageFromUrl(stimuli[count], view: imageView)
//            imageView.image = UIImage(named: stimuli[count])
            
            // Save audio file to database
//            let soundData = NSFileManager.defaultManager().contentsAtPath(getCacheDirectory().stringByAppendingPathComponent(fileName))
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
    
    func preparePlayer() {
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: getFileURL())
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            NSLog("Something went wrong")
        }
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
        
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutues, seconds and milliseconds, store
        // as string constants
        
        let strMinutes = minutes > 9 ? String(minutes): "0" + String(minutes)
        
        let strSeconds = seconds > 9 ? String(seconds): "0" + String(seconds)
        
        let strFraction = fraction > 9 ? String(fraction): "0" + String(fraction)
        
        //concatonate mins, seoncds and milliseconds, assign to UILable timercount
        
        timerCount.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
    }
    
    func startTimer() {
        if !timer.isValid {
            
            let aSelector : Selector = #selector(NamingTaskViewController.updateTime)
            
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    func resetTimer() {
        timer.invalidate()
        timerCount.text = "00:00:00"
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playBtn.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBtn.isEnabled = true
        playBtn.setTitle("Play", for: UIControlState())
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension String {
    func stringByAppendingPathComponent(_ pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
}
