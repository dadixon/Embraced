//
//  NamingTaskTaskViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/29/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

class NamingTaskTaskViewController: ActiveStepViewController {

    let TEST_NAME = "Naming"
    var audioRecorder: AVAudioRecorder!
    var recordedAudioURL: URL!
    var fileName = "sample.m4a"
    var isRecording = false
    var imagePath: [String]?
    var index = 0
    var documentPath: URL?
    var soundFileName = ""
    var timer = Timer()
    var totalSeconds = 15
    var showCountdownSeconds = 5
    var isStoring = false
    
    let taskImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let recordBtn: RecordButton = {
        var button = RecordButton(type: UIButton.ButtonType.custom) as RecordButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(recordPressed), for: .touchUpInside)
        return button
    }()
    
    let timerLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        nextBtn.isHidden = true
        
        setupView()
        
        imagePath = DataManager.sharedInstance.namingTaskTask
        
        setState()
    }
    
    private func setupView() {
        contentView.addSubview(taskImageView)
        contentView.addSubview(recordBtn)
        contentView.addSubview(timerLabel)
        
        taskImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        taskImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32.0).isActive = true
        taskImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32.0).isActive = true
        taskImageView.bottomAnchor.constraint(equalTo: recordBtn.topAnchor, constant: -32.0).isActive = true
        taskImageView.heightAnchor.constraint(equalToConstant: 420).isActive = true
        
        recordBtn.topAnchor.constraint(equalTo: taskImageView.bottomAnchor, constant: 32.0).isActive = true
        recordBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        recordBtn.widthAnchor.constraint(equalToConstant: 165.0).isActive = true
        recordBtn.heightAnchor.constraint(equalToConstant: 165.0).isActive = true
        recordBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        timerLabel.centerYAnchor.constraint(equalTo: recordBtn.centerYAnchor).isActive = true
        timerLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32.0).isActive = true
    }
    
    private func setState() {
        if let imageP = imagePath {
            var runCount = 0
            taskImageView.image = UIImage(named: imageP[index])
            recordBtn.btnRecord()
            recordBtn.isEnabled = true
            self.nextBtn.isHidden = true
            self.timerLabel.text = ""
            
            documentPath = Utility.getDocumentsDirectory().appendingPathComponent("\(FirebaseStorageManager.shared.pid!)/\(TEST_NAME)")
            soundFileName = "naming\(index + 1).m4a"
            
            do
            {
                try FileManager.default.createDirectory(atPath: documentPath!.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            
            timer.invalidate()
            
            timer = Timer(timeInterval: 1.0, repeats: true) { timer in
                runCount += 1
                
                if runCount >= (self.totalSeconds - self.showCountdownSeconds) {
                    self.timerLabel.text = "\(self.totalSeconds - runCount)"
                }
                
                if runCount == self.totalSeconds {
                    timer.invalidate()
                    if self.isRecording {
                        self.isStoring = true
                        self.finishRecording()
                    }
                    self.moveOn()
                }
            }
            timer.tolerance = 0.2
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    @objc func recordPressed() {
        if isRecording {
            finishRecording()
        } else {
            recordBtn.btnStop()
            isRecording = true
            startRecording()
        }
    }
    
    @objc func moveOn() {
        index += 1
        if index < imagePath!.count {
            setState()
        } else {
            self.performSegue(withIdentifier: "moveToDone", sender: nil)
        }
    }
    
    private func startRecording() {
        if let path = documentPath {
            let audioFilename = path.appendingPathComponent(soundFileName)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            recordedAudioURL = audioFilename
            
            let session = AVAudioSession.sharedInstance()
            try! session.setActive(true)
            
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            
            
            do {
                try audioRecorder = AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
                audioRecorder.record()
            } catch let error {
                print("Error: \(error)")
            }
        } else {
            SVProgressHUD.showError(withStatus: "No document path")
        }
    }
    
    private func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        recordBtn.btnRecord()
        isRecording = false
        
        externalStorage()
    }
    
    private func externalStorage() {
        SVProgressHUD.show()
        let filePath = "\(FirebaseStorageManager.shared.pid!)/\(TEST_NAME)/\(soundFileName)"
        
        if Utility.fileExist(filePath) {
            FirebaseStorageManager.shared.externalStorage(filePath: filePath, fileUrl: recordedAudioURL) { (uploadTask, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
                
                if let task = uploadTask {
                    task.observe(.success, handler: { snapshot in
                        NamingTaskModel.shared.files.append([self.index + 1: filePath])
                        
                        FirebaseStorageManager.shared.addDataToDocument(payload: [
                            "naming": NamingTaskModel.shared.getModel()
                        ])
                        
                        if !self.isStoring {
                            self.nextBtn.isHidden = false
                        }
                        
                        self.isStoring = false
                        Utility.deleteFile(filePath)
                        SVProgressHUD.dismiss()
                    })
                }
            }
        }
    }
}

extension NamingTaskTaskViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        } else {
            SVProgressHUD.showError(withStatus: "Recording Failed")
        }
    }
}
