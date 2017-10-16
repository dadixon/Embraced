//
//  NamingTaskViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class NamingTaskViewController: FrontViewController, AVAudioRecorderDelegate {

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
    @IBOutlet var completeView: UIView!

    @IBOutlet weak var practiceLabel: UILabel!
    @IBOutlet weak var practiceInstruction1: UILabel!
    @IBOutlet weak var pracitceInstruction2: UILabel!
    @IBOutlet weak var startBtn: NavigationButton!
    
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var exampleNextBtn: NavigationButton!
    @IBOutlet weak var exampleRecordBtn: UIButton!
    
    @IBOutlet weak var taskInstruction: UILabel!
    @IBOutlet weak var taskStartBtn: NavigationButton!
    @IBOutlet weak var taskNextBtn: NavigationButton!
    @IBOutlet weak var taskRecordBtn: UIButton!
    
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var completeSubmitBtn: UIButton!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var soundRecorder: AVAudioRecorder!
    var fileName = "testNamingAudioFile.m4a"
    
    var practice = [String]()
    var tasks = [String]()
    var count = 0
    var timeCount = 5
    
    let skipBtnDelay = 5.0 * Double(NSEC_PER_SEC)
    
    var startTime = TimeInterval()
    var timer = Timer()
    var isRunning = false
    var isTask = false
    let APIUrl = "http://www.embracedapi.ugr.es/"
    let userDefaults = UserDefaults.standard
    var token: String = ""
    var id: String = ""
    var headers: HTTPHeaders = [:]
    
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
        
        id = participant.string(forKey: "pid")!
        token = userDefaults.string(forKey: "token")!
        headers = [
            "x-access-token": token
        ]
        
        // Fetch images
        Alamofire.request(APIUrl + "api/naming_task/stimuli/" + language, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response)
            
            let statusCode = response.response?.statusCode
            
            if statusCode == 200 {
                guard let json = response.result.value as? [String: Any] else {
                    return
                }
                let practicePaths = json["practice"]! as! [String]
                let taskPaths = json["trial"]! as! [String]
                
                for x in 0..<practicePaths.count {
                    let pathArray = practicePaths[x].components(separatedBy: "/")
                    let path = pathArray[pathArray.count - 1]
                    
                    self.downloadAudioFile(urlString: "\(self.APIUrl)public/\(self.language)\(practicePaths[x])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, name: pathArray[pathArray.count - 1])
                    
                    self.practice.append(path)
                }
                
                for x in 0..<taskPaths.count {
                    let pathArray = taskPaths[x].components(separatedBy: "/")
                    let path = pathArray[pathArray.count - 1]
                    
                    self.downloadAudioFile(urlString: "\(self.APIUrl)public/\(self.language)\(taskPaths[x])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, name: pathArray[pathArray.count - 1])
                    
                    self.tasks.append(path)
                }
            }
        }
        
        
        
        
        
//        var stimuliURIs = [String: Any]()
//
//        let todoEndpoint: String = "http://www.embracedapi.ugr.es/stimuli/namingtask"
//
//        guard let url = URL(string: todoEndpoint) else {
//            print("Error: cannot create URL")
//            return
//        }
//
//        let urlRequest = URLRequest(url: url)
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
//            (data, response, error) -> Void in
//
//            let httpResponse = response as! HTTPURLResponse
//            let statusCode = httpResponse.statusCode
//
//            guard error == nil else {
//                print("error calling GET on stumiliNames")
//                print(error!)
//                return
//            }
//            // make sure we got data
//            guard let responseData = data else {
//                print("Error: did not receive data")
//                return
//            }
//
//            if (statusCode == 200) {
//                print("Everyone is fine, file downloaded successfully.")
//
//                do {
//                    guard let todo = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] else {
//                        print("error trying to convert data to JSON")
//                        return
//                    }
//
//                    stimuliURIs = todo
//
//                    self.practice = stimuliURIs["practice"] as! Array<String>
//                    self.tasks = stimuliURIs["task"] as! Array<String>
//
//
//                } catch {
//                    print("Error with Json: \(error)")
//                    return
//                }
//            }
//        })
//
//        task.resume()
        
        // Insert row in database
        id = participant.string(forKey: "pid")!
        token = userDefaults.string(forKey: "token")!
        headers = [
            "x-access-token": token
        ]
        
        Alamofire.request(APIUrl + "api/naming_task/new/" + id, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        }
        
        initialView.translatesAutoresizingMaskIntoConstraints = false
        trialView.translatesAutoresizingMaskIntoConstraints = false
        preTaskView.translatesAutoresizingMaskIntoConstraints = false
        taskView.translatesAutoresizingMaskIntoConstraints = false
        completeView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(initialView)
        
        let leftConstraint = initialView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let topConstraint = initialView.topAnchor.constraint(equalTo: containerView.topAnchor)
        let rightConstraint = initialView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottomConstraint = initialView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
        
        recordingSession = AVAudioSession.sharedInstance()
        
        practiceLabel.text = "Practice".localized(lang: language)
        practiceInstruction1.text = "naming_practice_instruction1".localized(lang: language)
        pracitceInstruction2.text = "naming_practice_instruction2".localized(lang: language)
        startBtn.setTitle("Start".localized(lang: language), for: .normal)
        recordBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        playBtn.setTitle("Play".localized(lang: language), for: .normal)
        taskRecordBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        exampleRecordBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
        loadingView.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func downloadAudioFile(urlString: String, name: String) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(name)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(urlString, to: destination)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }.response { response in
                if response.error == nil, let audioPath = response.destinationURL?.path {
                    let url = URL(fileURLWithPath: audioPath)
                    print(url)
                }
        }
    }
    
    func loadImageFromUrl(_ filename: String, view: UIImageView) {
//        let strurl = URL(string: filename)
//        let dtinternet = NSData(contentsOf: strurl!)
//        view.image = UIImage(data: dtinternet! as Data)
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
            finishRecording(button, success: false)
        }
    }
    
    
    
    func finishRecording(_ button: UIButton, success: Bool) {
        soundRecorder.stop()
        soundRecorder = nil
        
        if success {
            button.setTitle("Start_Record".localized(lang: language), for: .normal)
        }
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
    
    @objc func updateTime() {
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        var elapsedTime : TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        if seconds >= 15 {
            timerCount.text = String(timeCount)
            
            if timeCount == 0 {
                if soundRecorder != nil {
                    soundRecorder.stop()
                    soundRecorder = nil
                }

                taskRecordBtn.setTitle("Start_Record".localized(lang: language), for: .normal)
                
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
        playBtn.setTitle("Play".localized(lang: language), for: UIControlState())
        playBtn.isEnabled = false
    }
    
    func postToAPI(object: [String: AnyObject]) {
        let name = object["name"] as! String
        let fileURL = object["audio"] as! URL
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(fileURL, withName: "audio")
                multipartFormData.append(name.data(using: String.Encoding.utf8)!, withName: "name")
        }, usingThreshold: UInt64.init(),
           to: APIUrl + "api/digit_span/uploadfile/" + id,
           method: .post,
           headers: headers,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }})
    }
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        AppDelegate.position += 1
        nextViewController2(position: AppDelegate.position)
    }
    
    @IBAction func done(_ sender:AnyObject) {
//        showOverlay()
        
        // Push to the API
//        postToAPI()
        self.next(self)
    }
    
    // MARK: - Actions
    @IBAction func recordTapped(_ sender: UIButton) {
        if soundRecorder == nil {
            startRecording(sender, fileName: fileName)
        } else {
            finishRecording(sender, success: true)
            exampleRecordBtn.isEnabled = false
        }
    }
    
    @IBAction func recordTask(_ sender: AnyObject) {
        if soundRecorder == nil {
            startRecording(sender as! UIButton, fileName: "namingTask\(count).m4a")
        } else {
            finishRecording(sender as! UIButton, success: true)
            taskRecordBtn.isEnabled = false
            taskNextBtn.isHidden = false
        }
    }
    
    @IBAction func playSound(_ sender: UIButton) {
        if sender.titleLabel!.text == "Play".localized(lang: language) {
            recordBtn.isEnabled = false
            sender.setTitle("Stop_Recording".localized(lang: language), for: UIControlState())
            preparePlayer()
            soundPlayer?.play()
        } else {
            soundPlayer?.stop()
            sender.setTitle("Play".localized(lang: language), for: UIControlState())
        }
    }
    
    @IBAction func initialToTrial(_ sender: AnyObject) {
        setSubview(initialView, next: trialView)
        loadImageFromUrl(practice[count], view: imageView)
        
        exampleLabel.text = "Example".localized(lang: language)
        exampleNextBtn.setTitle("Next".localized(lang: language), for: .normal)
        exampleRecordBtn.isEnabled = true
    }
    
    @IBAction func nextExample(_ sender: AnyObject) {
        count += 1
        if count < practice.count {
            loadImageFromUrl(practice[count], view: imageView)
            exampleRecordBtn.isEnabled = true
        } else {
            setSubview(trialView, next: preTaskView)
            
            taskInstruction.text = "naming_task_instruction".localized(lang: language)
            taskStartBtn.setTitle("Start".localized(lang: language), for: .normal)
        }
    }
    
    @IBAction func toTask(_ sender: AnyObject) {
        isTask = true
        setSubview(preTaskView, next: taskView)
        taskNextBtn.setTitle("Next".localized(lang: language), for: .normal)
        count = 0
        loadImageFromUrl(tasks[count], view: taskImageView)
        startTimer()
        taskNextBtn.isHidden = true
    }
    
    @IBAction func nextTask(_ sender: AnyObject) {
        count += 1
        postToAPI(object: createPostObject(index: count))
        taskNextBtn.isHidden = true
        
        if count < tasks.count {
            taskRecordBtn.isEnabled = true
            loadImageFromUrl(tasks[count], view: taskImageView)
            resetTimer()
            startTimer()
        } else {
            resetTimer()
            setSubview(taskView, next: completeView)
            completeLabel.text = "Test_complete".localized(lang: language)
            completeSubmitBtn.setTitle("Submit".localized(lang: language), for: .normal)
        }
    }
    
    func createPostObject(index: Int) -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        
        let soundData = FileManager.default.contents(atPath: getCacheDirectory().stringByAppendingPathComponent("namingTask\(index-1).m4a"))
        let dataStr = soundData?.base64EncodedString(options: [])
        
        // Gather data for post
        jsonObject = [
            "index": index as AnyObject,
            "soundByte": dataStr as AnyObject
        ]
        
        return jsonObject
    }
}

extension String {
    func stringByAppendingPathComponent(_ pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
}
