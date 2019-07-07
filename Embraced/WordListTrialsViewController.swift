//
//  WordListTrialsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 4/19/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import CountdownView
import AVFoundation
import SVProgressHUD
import FirebaseStorage
import CoreData
import AVKit

class WordListTrialsViewController: ActiveStepViewController {

    var index = 1
    var isPlaying = false
    var isRecording = false
    var audioPlayer: AVAudioPlayer!
    var audioRecorder: AVAudioRecorder!
    var recordedAudioURL: URL!
    var trials = [String]()
    var fileName = ""
    var soundFileName = ""
    var instructions = [String]()
    var instructions2 = [String]()
    var documentPath: URL?
    
    let playBtn: UIButton = {
        var button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "listen2"), for: .normal)
        button.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
        return button
    }()
    
    let instructions2Label: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let recordBtn: UIButton = {
        var button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "record2"), for: .normal)
        button.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(recordPressed), for: .touchUpInside)
        return button
    }()
    
    
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        orientation = .landscape
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        trials = DataManager.sharedInstance.wordListTasks
        
        instructions = ["wordlist1_instructionA1".localized(lang: language),
                        "wordlist1_instructionA2".localized(lang: language),
                        "wordlist1_instructionA2".localized(lang: language),
                        "wordlist1_instructionA2".localized(lang: language),
                        "wordlist1_instructionA3".localized(lang: language),
                        "wordlist1_instructionA4".localized(lang: language),
                        "wordlist1_instructionA5".localized(lang: language)
        ]
        
        instructions2 = ["wordlist1_instructionB1".localized(lang: language),
                         "wordlist1_instructionB2".localized(lang: language),
                         "wordlist1_instructionB2".localized(lang: language),
                         "wordlist1_instructionB2".localized(lang: language),
                         "wordlist1_instructionB2".localized(lang: language),
                         "wordlist1_instructionB1".localized(lang: language),
                         ""
        ]
        
        initialSetup()
        
        documentPath = Utility.getDocumentsDirectory().appendingPathComponent("\(FirebaseStorageManager.shared.pid!)/WordList")
        
        do
        {
            try FileManager.default.createDirectory(atPath: documentPath!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        // Play storaged file
//        let storagePath = "testing/WordList/wordlist6.m4a"
//        let storageRef = storage.reference(withPath: storagePath)
//        print(storageRef)
//
//        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//            if let error = error {
//                print(error)
//            } else {
//                do {
//                    self.audioPlayer = try AVAudioPlayer(data: data!, fileTypeHint: AVFileType.m4a.rawValue)
//                    self.audioPlayer.delegate = self
//                    self.audioPlayer.play()
//                } catch {
//                    print("No Audio")
//                }
//
//            }
//        }
    }
    
    private func setupView() {
        contentView.addSubview(playBtn)
        contentView.addSubview(instructions2Label)
        contentView.addSubview(recordBtn)
        
        playBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        playBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 165.0).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 165.0).isActive = true
        
        instructions2Label.topAnchor.constraint(equalTo: playBtn.bottomAnchor, constant: 30.0).isActive = true
        instructions2Label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        recordBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        recordBtn.topAnchor.constraint(equalTo: instructions2Label.bottomAnchor, constant: 16.0).isActive = true
        recordBtn.widthAnchor.constraint(equalToConstant: 165.0).isActive = true
        recordBtn.heightAnchor.constraint(equalToConstant: 165.0).isActive = true
    }
    
    private func initialSetup() {
        titleLabel.text = "Trial".localized(lang: language) + " \(index)"
        instructionsLabel.text = instructions[index - 1]
        instructions2Label.text = instructions2[index - 1]
        
        if index < 7 {
            instructions2Label.isHidden = true
            recordBtn.isHidden = true
            recordBtn.isEnabled = true
            playBtn.isEnabled = true
        } else {
            instructions2Label.isHidden = true
            playBtn.isHidden = true
            recordBtn.isHidden = false
            recordBtn.isEnabled = true
        }
        
        nextBtn.isHidden = true
        
        soundFileName = "wordlist\(index).m4a"
    }
    
    @objc func playPressed() {
        if !isPlaying {
            CountdownView.show(countdownFrom: 3.0, spin: true, animation: .fadeIn, autoHide: true) {
                if self.index < 6 {
                    self.fileName = self.trials[0]
                } else {
                    self.fileName = self.trials[1]
                }
                self.playAudio(fileName: self.fileName)
                self.isPlaying = true
                self.playBtn.isEnabled = false
            }
        }
    }
    
    @objc func recordPressed() {
        if isRecording {
            finishRecording()
        } else {
            startRecording()
        }
    }
    
    @objc func moveOn() {
        index += 1
        
        if index == 8 {
            self.performSegue(withIdentifier: "moveToDone", sender: nil)
        } else {
            initialSetup()
        }
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
        isPlaying = false
        instructions2Label.isHidden = false
        recordBtn.isHidden = false
    }
    
    private func startRecording() {
        recordBtn.setImage(UIImage(named: "stop"), for: .normal)
        playBtn.isEnabled = false
        isRecording = true
        
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
        
        recordBtn.setImage(UIImage(named: "record2"), for: .normal)
        isRecording = false
        
        externalStorage()
    }
    
    private func externalStorage() {
        let filePath = "\(FirebaseStorageManager.shared.pid!)/WordList/\(soundFileName)"
//        let fileURL = getDocumentsDirectory().appendingPathComponent(filePath)
        
        if Utility.fileExist(filePath) {
//            var jsonObject = [String: AnyObject]()
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let participantRef = storageRef.child(filePath)
            
            participantRef.putFile(from: recordedAudioURL, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Error: \(error?.localizedDescription)")
                    SVProgressHUD.showError(withStatus: "An error has happened")
                }
                
                participantRef.downloadURL { (url, error) in
                    if error != nil {
                        print("Error: \(error?.localizedDescription)")
                    }
                    guard let downloadURL = url else { return }
                    
                    // Deprecate
//                    jsonObject = [
//                        "name": "wordList\(index)" as AnyObject,
//                        "audio": downloadURL.absoluteString as AnyObject
//                    ]
//
//                    Alamofire.request(self.APIUrl + "api/wordlist/" + self.id, method: .post, parameters: jsonObject, encoding: JSONEncoding.default, headers: self.headers).responseJSON { response in
//                    }
                    
                    switch (self.index) {
                        case 1: WordListModel.shared.task_1 = filePath
                        case 2: WordListModel.shared.task_2 = filePath
                        case 3: WordListModel.shared.task_3 = filePath
                        case 4: WordListModel.shared.task_4 = filePath
                        case 5: WordListModel.shared.task_5 = filePath
                        case 6: WordListModel.shared.interference = filePath
                        case 7: WordListModel.shared.shortTerm = filePath //downloadURL.absoluteString
                        default: break
                    }
                    
                    FirebaseStorageManager.shared.addDataToDocument(payload: [
                        "wordList": WordListModel.shared.printModel()
                    ])
                    
                    self.nextBtn.isHidden = false
                    
                    // Delete file from device
                    Utility.deleteFile(filePath)
                }
            }
        }
    }
}

extension WordListTrialsViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            finishedPlaying()
        }
    }
}

extension WordListTrialsViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordBtn.isEnabled = false
        } else {
            SVProgressHUD.showError(withStatus: "Recording Failed")
        }
    }
}
