//
//  LoadingScreenViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/17/17.
//  Copyright © 2017 Domonique Dixon. All rights reserved.
//

import UIKit
import Alamofire
//import ChameleonFramework

class LoadingScreenViewController: UIViewController {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet var fileFinishedLabel: UILabel!
    
    let participant = UserDefaults.standard
    var total = Int()
    var progress = Int()
    
    let APIUrl = "http://www.embracedapi.ugr.es/"
    var token: String = ""
    var id: String = ""
    var headers: HTTPHeaders = [:]
    var language = String()
    
    let group = DispatchGroup()
    
//    var pitchExamples = [[String]]()
    var pitchTasks = [[String]]()
    var pitchPractices = [[String]]()
    var digitalSpanForward = [String]()
    var digitalSpanForwardPractice = String()
    var digitalSpanBackward = [String]()
    var digitalSpanBackwardPractice = String()
    var stroopVideos = [String]()
    var stroopTasks = [String]()
    var namingTaskPracitce = [String]()
    var namingTaskTasks = [String]()
    var wordListTasks = [String]()
    var wordListRecognitions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
//        view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom, withFrame: view.frame, andColors: [UIColor(hexString:"6c7070")!, UIColor(hexString:"a5b09c")!])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        language = participant.string(forKey: "language")!
        progressBar.progress = 0.0
        logoView.image = UIImage(named: "logo")
        setupDownloadFiles()
    }

    func setupDownloadFiles() {
        Alamofire.request(APIUrl + "api/stimuli/files/" + language, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let statusCode = response.response?.statusCode
            
            if statusCode == 200 {
                guard let json = response.result.value as? [[String: Any]] else {
                    return
                }
                
//                var pitch: [String:Any] = [:]
//                var digitSpan: [String:Any] = [:]
//                var stroop: [String:Any] = [:]
//                var namingTask: [String:Any] = [:]
//                var wordList: [String:Any] = [:]
                
                for x in 0..<json.count {
//                    if json[x]["pitch"] != nil {
//                        pitch = json[x]["pitch"]! as! [String: Any]
//                    }
//                    if json[x]["digitSpan"] != nil {
//                        digitSpan = json[x]["digitSpan"]! as! [String: Any]
//                    }
//                    if json[x]["stroop"] != nil {
//                        stroop = json[x]["stroop"]! as! [String: Any]
//                    }
//                    if json[x]["namingTask"] != nil {
//                        namingTask = json[x]["namingTask"]! as! [String: Any]
//                    }
//                    if json[x]["wordlist"] != nil {
//                        wordList = json[x]["wordlist"]! as! [String: Any]
//                    }
                }
                
//                let pitchExamples = pitch["examples"]! as! [[String]]
//                let pitchTasks = pitch["tasks"]! as! [[String]]
//                let pitchPractices = pitch["practice"]! as! [[String]]
                
//                let forwardAudioPaths = digitSpan["forward"]! as! [String: Any]
//                let forwardTasks = forwardAudioPaths["tasks"] as! [String]
//                let forwardPractice = forwardAudioPaths["practice"] as! String
//                let backwardAudioPaths = digitSpan["backward"]! as! [String: Any]
//                let backwardTasks = backwardAudioPaths["tasks"] as! [String]
//                let backwardPractice = backwardAudioPaths["practice"] as! String
//
//                let stroopVideos = stroop["videos"] as! [String]
//                let stroopTasks = stroop["tasks"] as! [String]
                
//                let namingTaskPractice = namingTask["practice"] as! [String]
//                let namingTaskTasks = namingTask["task"] as! [String]
                
//                let wordListTasks = wordList["tasks"] as! [String]
//                let wordListRecognitions = wordList["recognition"] as! [String]

                self.total = 0

//                self.total += self.totalFromMulitArray(pitchExamples)
//                self.total += self.totalFromMulitArray(pitchPractices)
//                self.total += self.totalFromMulitArray(pitchTasks)
                
//                self.total += forwardTasks.count
//                self.total += 1 // forwardPractice
//                self.total += backwardTasks.count
//                self.total += 1 // backwardPractice
                
//                self.total += stroopVideos.count
//                self.total += stroopTasks.count
                
//                self.total += namingTaskPractice.count
//                self.total += namingTaskTasks.count
                
//                self.total += wordListRecognitions.count
//                self.total += wordListTasks.count

//                self.downloadMultiArray(pitchExamples, toArray: &self.pitchExamples)
//                self.downloadMultiArray(pitchPractices, toArray: &self.pitchPractices)
//                self.downloadMultiArray(pitchTasks, toArray: &self.pitchTasks)

//                self.digitalSpanForwardPractice = self.downloadFile(forwardPractice)
//                self.downloadArray(forwardTasks, toArray: &self.digitalSpanForward)
//                self.digitalSpanBackwardPractice = self.downloadFile(backwardPractice)
//                self.downloadArray(backwardTasks, toArray: &self.digitalSpanBackward)
                
//                self.downloadArray(stroopVideos, toArray: &self.stroopVideos)
//                self.downloadArray(stroopTasks, toArray: &self.stroopTasks)
                
//                self.downloadArray(namingTaskPractice, toArray: &self.namingTaskPracitce)
//                self.downloadArray(namingTaskTasks, toArray: &self.namingTaskTasks)
                
//                self.downloadArray(wordListTasks, toArray: &self.wordListTasks)
//                self.downloadArray(wordListRecognitions, toArray: &self.wordListRecognitions)

                self.group.notify(queue: .main) {
                    print("All requests are done")
//                    DataManager.sharedInstance.pitchExamples = self.pitchExamples
//                    DataManager.sharedInstance.pitchPractices = self.pitchPractices
//                    DataManager.sharedInstance.pitchTasks = self.pitchTasks
                    
//                    DataManager.sharedInstance.digitalSpanForwardPractice = self.digitalSpanForwardPractice
//                    DataManager.sharedInstance.digitalSpanForward = self.digitalSpanForward
//                    DataManager.sharedInstance.digitalSpanBackwardPractice = self.digitalSpanBackwardPractice
//                    DataManager.sharedInstance.digitalSpanBackward = self.digitalSpanBackward
                    
//                    DataManager.sharedInstance.stroopVideos = self.stroopVideos
//                    DataManager.sharedInstance.stroopTasks = self.stroopTasks
                    
//                    DataManager.sharedInstance.namingTaskPractice = self.namingTaskPracitce
//                    DataManager.sharedInstance.namingTaskTask = self.namingTaskTasks
                    
//                    DataManager.sharedInstance.wordListTasks = self.wordListTasks
//                    DataManager.sharedInstance.wordListRecognitions = self.wordListRecognitions

                    self.startTest()
                }
            }
        }
    }
    
    private func downloadAudioFile(urlString: String, name: String) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(name)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(urlString, to: destination)
            .downloadProgress { progress in
//                print("Download Progress: \(progress.fractionCompleted)")
            }.response { response in
                if response.error == nil {
                    self.group.leave()
                    self.progress = self.progress + 1
                    self.percentageLabel.text = String(Int(Float(self.progress) / Float(self.total) * 100)) + "%"
                    self.progressBar.setProgress(Float(self.progress) / Float(self.total), animated: true)
                    
                    let start = urlString.index(urlString.startIndex, offsetBy: 30)
                    let end = urlString.index(urlString.endIndex, offsetBy: 0)
                    let range = start..<end
                    
                    let mySubstring = urlString[range]
                    
                    self.fileFinishedLabel.text = String(mySubstring)
                }
        }
    }
    
    private func totalFromMulitArray(_ array: [[Any]]) -> Int {
        var total = 0
        
        for x in 0..<array.count {
            total += array[x].count
        }
        
        return total
    }
    
    private func downloadFile(_ path: String) -> String {
        var pathArray = path.components(separatedBy: "/")
        let name = pathArray[pathArray.count - 1]
        
        self.group.enter()
        self.downloadAudioFile(urlString: "\(self.APIUrl)public/\(self.language)/\(path)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, name: name)
        return name
    }
    private func downloadArray(_ array: [String], toArray: inout [String]) {
        for x in 0..<array.count {
            let pathArray = array[x].components(separatedBy: "/")
            let path = pathArray[pathArray.count - 1]
            
            self.group.enter()
            self.downloadAudioFile(urlString: "\(self.APIUrl)public/\(self.language)\(array[x])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, name: path)
            toArray.append(path)
        }
    }
    private func downloadMultiArray(_ array: [[String]], toArray: inout [[String]]) {
        for x in 0..<array.count {
            var examplesString = [String]()
            for y in 0..<array[x].count {
                let pathArray = array[x][y].components(separatedBy: "/")
                examplesString.append(pathArray[pathArray.count - 1])
                self.group.enter()
                self.downloadAudioFile(urlString: "\(self.APIUrl)public/\(self.language)\(array[x][y])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, name: pathArray[pathArray.count - 1])
            }
            toArray.append(examplesString)
        }
    }
    
    func startTest() {
        // Save test timer
        let date = Date()
        participant.setValue(date, forKey: "StartDate")
        
        AppDelegate.testPosition += 1
        self.navigationController?.pushViewController(TestOrder.sharedInstance.getTest(AppDelegate.testPosition), animated: true)
    }
}
