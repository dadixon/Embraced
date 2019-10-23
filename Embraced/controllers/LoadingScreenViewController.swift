//
//  LoadingScreenViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/17/17.
//  Copyright © 2017 Domonique Dixon. All rights reserved.
//

import UIKit

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
        
    }
    
    private func downloadAudioFile(urlString: String, name: String) {
        
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
