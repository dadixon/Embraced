//
//  AudioPlaybackViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/9/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlaybackViewController: ActiveStepViewController {

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
    
    let playBtn: PlayButton = {
        var button = PlayButton(type: UIButton.ButtonType.custom) as PlayButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        playBtn.isEnabled = false
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
        
        recordBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -150.0).isActive = true
        recordBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        recordBtn.widthAnchor.constraint(equalToConstant: 165.0).isActive = true
        recordBtn.heightAnchor.constraint(equalToConstant: 165.0).isActive = true
        
        playBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 150.0).isActive = true
        playBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 165.0).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 165.0).isActive = true
    }
    
    
    @objc func recordPressed() {
        if isRecording {
            recordBtn.btnRecord()
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
            playBtn.btnStop()
            recordBtn.isEnabled = false
            isPlaying = true
            playRecording()
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
//        if #available(iOS 10.0, *) {
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
//        } else {
            // Fallback on earlier versions
//        }
        
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
        
        playBtn.isEnabled = true
        isRecording = false
    }
    
    private func playRecording() {
        let audioFilename = Utility.getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.delegate = self
            audioPlayer.play()
        } catch {
            print("No Audio")
        }
    }
    private func finishedPlaying() {
        recordBtn.isEnabled = true
        playBtn.btnPlay()
        playBtn.isEnabled = false
        isPlaying = false
    }
}

extension AudioPlaybackViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordBtn.isEnabled = true
        } else {
            print("Recording failed")
        }
    }
}

extension AudioPlaybackViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            finishedPlaying()
        }
    }
}
