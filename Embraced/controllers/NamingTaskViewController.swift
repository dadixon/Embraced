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
    
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var isRunning = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRecorder()
        
        let requestURL: NSURL = NSURL(string: "http://api.girlscouts.harryatwal.com/name_task")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do {
                    self.stimuli = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments) as! [String]
                    self.loadImageFromUrl(self.stimuli[0], view: self.imageView)
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        
        task.resume()
        
        startTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
    }
    
    func setupRecorder() {
        let recordSettings : [String:AnyObject] = [AVFormatIDKey: NSNumber(int: Int32(kAudioFormatAppleLossless)),
                              AVEncoderAudioQualityKey: NSNumber(int: Int32(AVAudioQuality.Max.rawValue)),
                              AVEncoderBitRateKey: NSNumber(int: Int32(320000)),
                              AVNumberOfChannelsKey: NSNumber(int: 2),
                              AVSampleRateKey: NSNumber(float: Float(44100.0))]
        
        do {
            soundRecorder = try AVAudioRecorder(URL: getFileURL(), settings: recordSettings)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            NSLog("Something went wrong")
        }
        
    }

    func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) 
        
        return paths[0]
    }
    
    func getFileURL() -> NSURL {
        let path = getCacheDirectory().stringByAppendingPathComponent(fileName)
        let filePath = NSURL(fileURLWithPath: path)
        
        return filePath
    }
    
    @IBAction func record(sender: UIButton) {
        if sender.titleLabel!.text == "Record" {
            soundRecorder.record()
            sender.setTitle("Stop", forState: .Normal)
            playBtn.enabled = false
        } else {
            soundRecorder.stop()
            sender.setTitle("Record", forState: .Normal)
            playBtn.enabled = false
            resetTimer()
            startTimer()
            
            count += 1
            loadImageFromUrl(stimuli[count], view: imageView)
//            imageView.image = UIImage(named: stimuli[count])
            
            // Save audio file to database
//            let soundData = NSFileManager.defaultManager().contentsAtPath(getCacheDirectory().stringByAppendingPathComponent(fileName))
        }
    }
    
    @IBAction func playSound(sender: UIButton) {
        if sender.titleLabel!.text == "Play" {
            recordBtn.enabled = false
            sender.setTitle("Stop", forState: .Normal)
            preparePlayer()
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            sender.setTitle("Play", forState: .Normal)
        }
    }
    
    func preparePlayer() {
        do {
            soundPlayer = try AVAudioPlayer(contentsOfURL: getFileURL())
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            NSLog("Something went wrong")
        }
    }
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        var elapsedTime : NSTimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        
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
        if !timer.valid {
            
            let aSelector : Selector = #selector(NamingTaskViewController.updateTime)
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }
    
    func resetTimer() {
        timer.invalidate()
        timerCount.text = "00:00:00"
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        playBtn.enabled = true
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        recordBtn.enabled = true
        playBtn.setTitle("Play", forState: .Normal)
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
    func stringByAppendingPathComponent(pathComponent: String) -> String {
        return (self as NSString).stringByAppendingPathComponent(pathComponent)
    }
}