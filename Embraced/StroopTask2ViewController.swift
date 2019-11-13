//
//  StroopTask2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/25/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD
import FirebaseStorage

class StroopTask2ViewController: ActiveStepViewController {

    let TEST_NAME = "Stroop"
    var audioRecorder: AVAudioRecorder!
    var recordedAudioURL: URL!
    var fileName = "sample.m4a"
    var isRecording = false
    var imagePath: String?
    let index = 1
    var documentPath: URL?
    var soundFileName = ""
    var start: CFAbsoluteTime!
    var reactionTime: Int?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        start = CFAbsoluteTimeGetCurrent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        nextBtn.setTitle("Done".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        nextBtn.isHidden = true
        
        setupView()
        
        imagePath = DataManager.sharedInstance.stroopTasks[index]
        
        if let imageP = imagePath {
            taskImageView.image = UIImage(named: imageP)
        }
        
        documentPath = Utility.getDocumentsDirectory().appendingPathComponent("\(FirebaseStorageManager.shared.pid!)/\(TEST_NAME)")
        soundFileName = "stroop\(index + 1).m4a"
        
        do
        {
            try FileManager.default.createDirectory(atPath: documentPath!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
    }
    
    private func setupView() {
        contentView.addSubview(taskImageView)
        contentView.addSubview(recordBtn)
        
        taskImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        taskImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        taskImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        taskImageView.bottomAnchor.constraint(equalTo: recordBtn.topAnchor, constant: 32.0).isActive = true
        
        recordBtn.topAnchor.constraint(equalTo: taskImageView.bottomAnchor, constant: 32.0).isActive = true
        recordBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        recordBtn.widthAnchor.constraint(equalToConstant: 165.0).isActive = true
        recordBtn.heightAnchor.constraint(equalToConstant: 165.0).isActive = true
        recordBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
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
        self.performSegue(withIdentifier: "moveToPreTask3", sender: nil)
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
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        let mill = elapsed * 1000
        reactionTime = Int(mill)
        
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
                    task.observe(.success, handler: { (snapshot) in
                        StroopModel.shared.file_2 = filePath
                        StroopModel.shared.rt_2 = self.reactionTime
                        
                        FirebaseStorageManager.shared.addDataToDocument(payload: [
                            "stroop": StroopModel.shared.getModel()
                        ])
                        
                        self.nextBtn.isHidden = false
                        
                        Utility.deleteFile(filePath)
                        SVProgressHUD.dismiss()
                    })
                }
            }
        }
    }
}

extension StroopTask2ViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordBtn.isEnabled = false
        } else {
            SVProgressHUD.showError(withStatus: "Recording Failed")
        }
    }
}
