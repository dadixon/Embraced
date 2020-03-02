//
//  DigitSpanPracticeViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/6/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation

class DigitSpanPracticeViewController: ActiveStepViewController {

    var soundPath = String()
    var audioPlayer: AVAudioPlayer!
    var audioRecorder: AVAudioRecorder!
    var recordedAudioURL: URL!
    var fileName = "sample.m4a"
    var isRecording = false
    var isPlaying = false
    
    let recordBtn: RecordButton = {
        var button = RecordButton(type: UIButton.ButtonType.custom) as RecordButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(recordPressed), for: .touchUpInside)
        return button
    }()
    
    let playBtn: ListenButton = {
        var button = ListenButton(type: UIButton.ButtonType.custom) as ListenButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .portrait
        rotateOrientation = .portrait
        
        titleLabel.text = "Practice".localized(lang: language)
        instructionsLabel.text = "digital_practice_2".localized(lang: language)
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        soundPath = "digitSpan/\(language)/\(DataManager.sharedInstance.digitalSpanForwardPractice)"
        
        setupView()
        
        recordBtn.isEnabled = false
    }
    
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
    
    @objc func moveOn() {
        if isPlaying {
            audioRecorder.stop()
            audioRecorder = nil
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
        }
        
//        self.performSegue(withIdentifier: "moveToTask", sender: nil)
        let vc = DigitSpanTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
            playAudio(fileName: soundPath)
            playBtn.isEnabled = false
            recordBtn.isEnabled = false
        }
    }
    
    private func startRecording() {
        let audioFilename = Utility.getDocumentsDirectory().appendingPathComponent(fileName)
        
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
    }
    
    private func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        recordBtn.btnRecord()
        playBtn.isEnabled = true
        isRecording = false
    }
    
    private func playAudio(fileName: String) {
        let filePath = Utility.getAudio(path: fileName)
        
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
    
    private func finishedPlaying() {
        recordBtn.isEnabled = true
        playBtn.isEnabled = true
        isPlaying = false
    }
}

extension DigitSpanPracticeViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordBtn.isEnabled = true
        } else {
            print("Recording failed")
        }
    }
}

extension DigitSpanPracticeViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            finishedPlaying()
        }
    }
}
