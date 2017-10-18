//
//  LoadingScreenViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/17/17.
//  Copyright © 2017 Domonique Dixon. All rights reserved.
//

import UIKit
import Alamofire
import ChameleonFramework

class LoadingScreenViewController: UIViewController {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let participant = UserDefaults.standard
    var total = Int()
    var progress = Int()
    
    let APIUrl = "http://www.embracedapi.ugr.es/"
    var token: String = ""
    var id: String = ""
    var headers: HTTPHeaders = [:]
    var language = String()
    
    let group = DispatchGroup()
    
    var examples = [[String]]()
    var tasks = [[String]]()
    var practices = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom, withFrame: view.frame, andColors: [UIColor(hexString:"6c7070"), UIColor(hexString:"a5b09c")])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        language = participant.string(forKey: "language")!
        progressBar.progress = 0.0
        logoView.image = UIImage(named: "LOGO_r1_c1.png")
        setupDownloadFiles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupDownloadFiles() {
        Alamofire.request(APIUrl + "api/stimuli/files/" + language, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response)
            
            let statusCode = response.response?.statusCode
            
            if statusCode == 200 {
                guard let json = response.result.value as? [[String: Any]] else {
                    return
                }
                
                var pitch: [String:Any] = [:]
                
                for x in 0..<json.count {
                    if json[x]["pitch"] != nil {
                        pitch = json[x]["pitch"]! as! [String: Any]
                    }
                }
                
                let pitchExamples = pitch["examples"]! as! [[String]]
                let pitchTasks = pitch["tasks"]! as! [[String]]
                let pitchPractices = pitch["practice"]! as! [[String]]

                self.total = 0

                self.total += self.totalFromArray(pitchExamples)
                self.total += self.totalFromArray(pitchPractices)
                self.total += self.totalFromArray(pitchTasks)

                print(self.total)

                self.downloadMultiArray(pitchExamples, toArray: &self.examples)
                self.downloadMultiArray(pitchPractices, toArray: &self.practices)
                self.downloadMultiArray(pitchTasks, toArray: &self.tasks)
                
//                for x in 0..<pitchExamples.count {
//                    var examplesString = [String]()
//                    for y in 0..<pitchExamples[x].count {
//                        let pathArray = pitchExamples[x][y].components(separatedBy: "/")
//                        examplesString.append(pathArray[pathArray.count - 1])
//                        self.group.enter()
//                        self.downloadAudioFile(urlString: "http://www.embracedapi.ugr.es/public/\(self.language)\(pitchExamples[x][y])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, name: pathArray[pathArray.count - 1])
//                    }
//                    self.examples.append(examplesString)
//                }
//
//                for x in 0..<pitchPractices.count {
//                    var practicesString = [String]()
//                    for y in 0..<pitchPractices[x].count {
//                        let pathArray = pitchPractices[x][y].components(separatedBy: "/")
//                        practicesString.append(pathArray[pathArray.count - 1])
//                        self.group.enter()
//                        self.downloadAudioFile(urlString: "http://www.embracedapi.ugr.es/public/\(self.language)\(pitchPractices[x][y])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, name: pathArray[pathArray.count - 1])
//                    }
//                    self.practices.append(practicesString)
//                }
//
//                for x in 0..<pitchTasks.count {
//                    var tasksString = [String]()
//                    for y in 0..<pitchTasks[x].count {
//                        let pathArray = pitchTasks[x][y].components(separatedBy: "/")
//                        tasksString.append(pathArray[pathArray.count - 1])
//                        self.group.enter()
//                        self.downloadAudioFile(urlString: "http://www.embracedapi.ugr.es/public/\(self.language)\(pitchTasks[x][y])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, name: pathArray[pathArray.count - 1])
//                    }
//                    self.tasks.append(tasksString)
//                }

                self.group.notify(queue: .main) {
                    print("All requests are done")
                    DataManager.sharedInstance.pitchExamples = self.examples
                    DataManager.sharedInstance.pitchPractices = self.practices
                    DataManager.sharedInstance.pitchTasks = self.tasks

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
                }
        }
    }
    
    private func totalFromArray(_ array: [[Any]]) -> Int {
        var total = 0
        
        for x in 0..<array.count {
            total += array[x].count
        }
        
        return total
    }
    
    private func downloadMultiArray(_ array: [[String]], toArray: inout [[String]]) {
        for x in 0..<array.count {
            var examplesString = [String]()
            for y in 0..<array[x].count {
                let pathArray = array[x][y].components(separatedBy: "/")
                examplesString.append(pathArray[pathArray.count - 1])
                self.group.enter()
                self.downloadAudioFile(urlString: "http://www.embracedapi.ugr.es/public/\(self.language)\(array[x][y])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, name: pathArray[pathArray.count - 1])
            }
            toArray.append(examplesString)
        }
    }
    
    func startTest() {
        // TODO: Update participant language chosen in the db
        
        var navigationArray = self.navigationController?.viewControllers
        
        navigationArray?.remove(at: 0)
        
        let vc: UIViewController!
        
        var tests = ["Questionnaire", "MoCA/MMSE", "Rey Complex Figure 1", "Clock Drawing Test", "Rey Complex Figure 2", "Trail Making", "Pitch", "Digit Span", "Rey Complex Figure 3", "Rey Complex Figure 4", "Matrices", "Continuous Performance Test", "Motor Tasks", "Word List 1", "Stroop Test", "Cancellation Test", "Word List 2", "Naming Task", "Comprehension Task", "Eye Test"]
        if let test = participant.array(forKey: "Tests") {
            tests = test as! [String]
        }
        
        participant.set(tests, forKey: "Tests")
        
        switch tests[0] {
        case "Questionnaire":
            vc = QuestionnaireViewController()
        case "MoCA/MMSE":
            vc = MOCAMMSETestViewController()
        case "Rey Complex Figure 1":
            vc = ReyComplexFigureViewController()
        case "Clock Drawing Test":
            vc = ClockDrawingTestViewController()
        case "Rey Complex Figure 2":
            vc = ReyComplexFigure2ViewController()
        case "Trail Making":
            vc = TrailMakingTestViewController()
        case "Pitch":
            vc = PitchViewController()
        case "Digit Span":
            vc = DigitalSpanViewController()
        case "Rey Complex Figure 3":
            vc = ReyComplexFigure3ViewController()
        case "Rey Complex Figure 4":
            vc = ReyFigureComplex4ViewController()
        case "Matrices":
            vc = MatricesViewController()
        case "Continuous Performance Test":
            vc = CPTViewController()
        case "Motor Tasks":
            vc = PegboardViewController()
        case "Word List 1":
            vc = WordListViewController()
        case "Stroop Test":
            vc = StroopViewController()
        case "Cancellation Test":
            vc = CancellationTestViewController()
        case "Word List 2":
            vc = WordList2ViewController()
        case "Naming Task":
            vc = NamingTaskViewController()
        case "Comprehension Task":
            vc = ComprehensionViewController()
        case "Eye Test":
            vc = EyeTestViewController()
        default:
            vc = UserInputViewController()
        }
        
        navigationArray?.append(vc)
        self.navigationController?.setViewControllers(navigationArray!, animated: true)
    }
}
