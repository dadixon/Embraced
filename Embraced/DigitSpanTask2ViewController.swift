//
//  DigitSpanTask2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/6/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD
import FirebaseStorage

class DigitSpanTask2ViewController: ActiveStepViewController {

    var index = 0
    var soundPaths = [String]()
    var audioPlayer: AVAudioPlayer!
    var audioRecorder: AVAudioRecorder!
    var recordedAudioURL: URL!
    var fileName = "sample.m4a"
    var isRecording = false
    var isPlaying = false
    var documentPath: URL?
    var soundFileName = ""
    
    let playBtn: PlayButton = {
        var button = PlayButton(type: UIButton.ButtonType.custom) as PlayButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
        return button
    }()
    
    let recordBtn: RecordButton = {
        var button = RecordButton(type: UIButton.ButtonType.custom) as RecordButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(recordPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        // Delete sample file
        let sampleFile = Utility.getDocumentsDirectory().appendingPathComponent(fileName)
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: sampleFile.path) {
            do {
                try FileManager.default.removeItem(at: sampleFile)
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .portrait
        rotateOrientation = .portrait
        
        instructionsLabel.text = "digital_begin_round".localized(lang: language)
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        soundPaths = DataManager.sharedInstance.digitalSpanForward
        
        initialSetup()
        setupView()
        
        recordBtn.isEnabled = false
        
        documentPath = Utility.getDocumentsDirectory().appendingPathComponent("\(FirebaseStorageManager.shared.pid!)/DigitSpan")
        
        do
        {
            try FileManager.default.createDirectory(atPath: documentPath!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
    }
    
    private func initialSetup() {
        titleLabel.text = "Round".localized(lang: language) + " \(index + 1)"
        soundFileName = "backward\(index + 1).m4a"
        playBtn.isEnabled = true
        recordBtn.isEnabled = false
        nextBtn.isHidden = true
    }
    
    private func setupView() {
        contentView.addSubview(recordBtn)
        contentView.addSubview(playBtn)
        
        playBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -150.0).isActive = true
        playBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 165.0).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 165.0).isActive = true
        
        recordBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 150.0).isActive = true
        recordBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        recordBtn.widthAnchor.constraint(equalToConstant: 165.0).isActive = true
        recordBtn.heightAnchor.constraint(equalToConstant: 165.0).isActive = true
    }
    
    @objc func recordPressed() {
        if isRecording {
            finishRecording()
        } else {
            recordBtn.btnStop()
            playBtn.isEnabled = false
            isRecording = true
            startRecording()
        }
    }
    
    @objc func playPressed() {
        if !isPlaying {
            fileName = soundPaths[index]
            playAudio(fileName: fileName)
            playBtn.isEnabled = false
            recordBtn.isEnabled = false
        }
    }
    
    @objc func moveOn() {
        index += 1
        
        if index == soundPaths.count {
            self.performSegue(withIdentifier: "moveToDone", sender: nil)
        } else {
            initialSetup()
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
        recordBtn.isEnabled = false
        isRecording = false
        
        externalStorage()
        
        nextBtn.isHidden = false
    }
    
    private func playAudio(fileName: String) {
        let fileNameArray = fileName.components(separatedBy: ".")
        
        if let dirPath = Bundle.main.path(forResource: fileNameArray[0], ofType: fileNameArray[1]) {
            let filePath = URL(fileURLWithPath: dirPath)
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            }
            catch {
                // report for an error
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: filePath)
                audioPlayer.delegate = self
                audioPlayer.play()
            } catch {
                print("No Audio")
            }
        }
    }
    
    private func finishedPlaying() {
        recordBtn.isEnabled = true
        isPlaying = false
    }
    
    private func externalStorage() {
        let filePath = "\(FirebaseStorageManager.shared.pid!)/DigitSpan/\(soundFileName)"
        
        if Utility.fileExist(filePath) {
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let participantRef = storageRef.child(filePath)
            
            participantRef.putFile(from: recordedAudioURL, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Error: \(error?.localizedDescription)")
                    SVProgressHUD.showError(withStatus: "An error has happened")
                }
                
                switch (self.index) {
                case 0:
                    DigitSpanModel.shared.DSBWD_1_file = filePath
                    break
                case 1:
                    DigitSpanModel.shared.DSBWD_2_file = filePath
                    break
                case 2:
                    DigitSpanModel.shared.DSBWD_3_file = filePath
                    break
                case 3:
                    DigitSpanModel.shared.DSBWD_4_file = filePath
                    break
                case 4:
                    DigitSpanModel.shared.DSBWD_5_file = filePath
                    break
                case 5:
                    DigitSpanModel.shared.DSBWD_6_file = filePath
                    break
                case 6:
                    DigitSpanModel.shared.DSBWD_7_file = filePath
                    break
                case 7:
                    DigitSpanModel.shared.DSBWD_8_file = filePath
                    break
                case 8:
                    DigitSpanModel.shared.DSBWD_9_file = filePath
                    break
                case 9:
                    DigitSpanModel.shared.DSBWD_10_file = filePath
                    break
                case 10:
                    DigitSpanModel.shared.DSBWD_11_file = filePath
                    break
                case 11:
                    DigitSpanModel.shared.DSBWD_12_file = filePath
                    break
                case 12:
                    DigitSpanModel.shared.DSBWD_13_file = filePath
                    break
                case 13:
                    DigitSpanModel.shared.DSBWD_14_file = filePath
                    break
                default:
                    break
                }
                
                
                FirebaseStorageManager.shared.addDataToDocument(payload: [
                    "digitSpan": DigitSpanModel.shared.printModel()
                    ])
                
                self.nextBtn.isHidden = false
                
                // Delete file from device
                Utility.deleteFile(filePath)
            }
        }
    }
}

extension DigitSpanTask2ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            finishedPlaying()
        }
    }
}

extension DigitSpanTask2ViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordBtn.isEnabled = true
        } else {
            print("Recording failed")
        }
    }
}
