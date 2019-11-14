//
//  WordList2TaskViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/3/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD
import FirebaseStorage

class WordList2TaskViewController: ActiveStepViewController {

    let TEST_NAME = "WordList"
    var audioRecorder: AVAudioRecorder!
    var recordedAudioURL: URL!
    var isRecording = false
    var soundFileName = ""
    var documentPath: URL?
    
    let recordBtn: RecordButton = {
        var button = RecordButton(type: UIButton.ButtonType.custom) as RecordButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(recordPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        instructionsLabel.text = "wordlist2_instruction".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        nextBtn.isHidden = true
        
        soundFileName = "wordlist_longTerm.m4a"
        
        setupView()
        
        documentPath = Utility.getDocumentsDirectory().appendingPathComponent("\(FirebaseStorageManager.shared.pid!)/\(TEST_NAME)")
        
        do
        {
            try FileManager.default.createDirectory(atPath: documentPath!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
    }
    
    private func setupView() {
        contentView.addSubview(recordBtn)
        
        recordBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        recordBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        recordBtn.widthAnchor.constraint(equalToConstant: 165.0).isActive = true
        recordBtn.heightAnchor.constraint(equalToConstant: 165.0).isActive = true
    }
    
    @objc func moveOn() {
        self.performSegue(withIdentifier: "moveToRecognition", sender: nil)
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
                    task.observe(.success, handler: { (snapshot) in
                        WordListModel.shared.longTerm = filePath
                        
                        FirebaseStorageManager.shared.addDataToDocument(payload: [
                            "wordList": WordListModel.shared.getModel()
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

extension WordList2TaskViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordBtn.isEnabled = false
        } else {
            SVProgressHUD.showError(withStatus: "Recording Failed")
        }
    }
}
