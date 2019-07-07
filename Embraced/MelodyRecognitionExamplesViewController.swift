//
//  MelodyRecognitionExample1ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/6/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation

class MelodyRecognitionExamplesViewController: ActiveStepViewController {
    
    var index = 0
    var instructions = [String]()
    var audioPlayer: AVAudioPlayer!
    var firstSoundPath = ""
    var secondSoundPath = ""
    var examples = [[String]]()
    let exampleAnswers = ["S", "D", "D"]
    var timer = Timer()
    
    let audioCountLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 90.0)
        return label
    }()
    
    let confirmationLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 36.0)
        label.numberOfLines = 0
        return label
    }()
    
    let playBtn: UIButton = {
        var button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "listen2"), for: .normal)
        button.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
        return button
    }()
    
    let answerSegment: UISegmentedControl = {
        var segment = UISegmentedControl(items: ["asdf", "asdf"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 27)], for: .normal)
        segment.addTarget(self, action: #selector(segmentPressed), for: .valueChanged)
        return segment
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addSubview(audioCountLabel)
        contentView.addSubview(confirmationLabel)
        contentView.addSubview(playBtn)
        contentView.addSubview(answerSegment)
        
        playBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32.0).isActive = true
        playBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 165.0).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 165.0).isActive = true
        
        audioCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        audioCountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        audioCountLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0).isActive = true
        audioCountLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0).isActive = true
        
        answerSegment.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        answerSegment.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        answerSegment.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        answerSegment.bottomAnchor.constraint(equalTo: confirmationLabel.topAnchor, constant: -16.0).isActive = true
        
        confirmationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
        confirmationLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        confirmationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0).isActive = true
        confirmationLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        instructions = [
            "pitch_example_1".localized(lang: language),
            "pitch_example_2".localized(lang: language),
            "pitch_example_3".localized(lang: language)
        ]
        
        examples = DataManager.sharedInstance.pitchExamples
        
        answerSegment.setTitle("Same".localized(lang: language), forSegmentAt: 0)
        answerSegment.setTitle("Different".localized(lang: language), forSegmentAt: 1)
        
        initialSetup()        
    }
    
    private func initialSetup() {
        titleLabel.text = "Example".localized(lang: language) + " \(index + 1)"
        instructionsLabel.text = instructions[index]
        
        audioCountLabel.isHidden = true
        
        confirmationLabel.text = "Incorrect_2".localized(lang: language)
        confirmationLabel.isHidden = true
        
        answerSegment.isHidden = true
        nextBtn.isHidden = true
    }
    
    @objc func playPressed() {
        setUpSounds(examples[index])
        self.playAudio(fileName: firstSoundPath)
        resetControls()
    }
    
    @objc func moveOn() {
        index += 1
        
        if index == examples.count {
            self.performSegue(withIdentifier: "moveToPractice", sender: nil)
        } else {
            initialSetup()
        }
    }

    @objc func timerHandler() {
        audioCountLabel.text = "2"
        playAudio(fileName: secondSoundPath)
        
        resetTimer()
        firstSoundPath = ""
        secondSoundPath = ""
    }
    
    @objc func segmentPressed() {
        confirmationLabel.isHidden = false
        nextBtn.isHidden = false
        answerCheck()
    }
    
    private func resetControls() {
        audioCountLabel.text = "1"
        audioCountLabel.isHidden = false
        playBtn.isEnabled = false
        confirmationLabel.isHidden = true
        answerSegment.isHidden = true
        answerSegment.selectedSegmentIndex = UISegmentedControl.noSegment
        nextBtn.isHidden = true
    }
    
    private func answerCheck() {
        if ((answerSegment.selectedSegmentIndex == 0 && exampleAnswers[index] == "S") ||
            (answerSegment.selectedSegmentIndex == 1 && exampleAnswers[index] == "D")) {
            confirmationLabel.text = "Correct".localized(lang: language)
        } else {
            confirmationLabel.text = "Incorrect_2".localized(lang: language)
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
    
    private func setUpSounds(_ sounds: [String]) {
        if sounds.count > 1 {
            firstSoundPath = sounds[0]
            secondSoundPath = sounds[1]
        } else {
            firstSoundPath = sounds[0]
            secondSoundPath = sounds[0]
        }
    }
    
    private func finishedPlaying() {
        if secondSoundPath != "" {
            startTimer()
        } else {
            audioCountLabel.text = ""
            answerSegment.isHidden = false
            playBtn.isEnabled = true
        }
    }
    
    private func startTimer() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: false)
        }
    }
    
    private func resetTimer() {
        timer.invalidate()
    }
}

extension MelodyRecognitionExamplesViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            finishedPlaying()
        }
    }
}
