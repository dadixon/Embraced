//
//  MelodyRecognitionPracticeViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/5/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation

class MelodyRecognitionPracticeViewController: ActiveStepViewController {

    var index = 0
    var audioPlayer: AVAudioPlayer!
    var firstSoundPath = ""
    var secondSoundPath = ""
    var practices = [[String]]()
    let practiceAnswers = ["D", "D", "S", "D", "D"]
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
    
    let playBtn: ListenButton = {
        var button = ListenButton(type: UIButton.ButtonType.custom) as ListenButton
        button.translatesAutoresizingMaskIntoConstraints = false
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
        
        instructionsLabel.text = "pitch_practice_1".localized(lang: language)
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        practices = DataManager.sharedInstance.pitchPractices
        
        answerSegment.setTitle("Same".localized(lang: language), forSegmentAt: 0)
        answerSegment.setTitle("Different".localized(lang: language), forSegmentAt: 1)
        
        initialSetup()
    }
    
    private func initialSetup() {
        titleLabel.text = "Practice".localized(lang: language)
        
        audioCountLabel.isHidden = true
        
        confirmationLabel.text = "Incorrect_2".localized(lang: language)
        confirmationLabel.isHidden = true
        
        answerSegment.isHidden = true
        nextBtn.isHidden = true
    }
    
    @objc func playPressed() {
        setUpSounds(practices[index])
        playAudio(fileName: firstSoundPath)
        resetControls()
    }
    
    @objc func moveOn() {
        index += 1
        
        if index == practices.count {
//            self.performSegue(withIdentifier: "moveToInstructions2", sender: nil)
            let vc = MelodyRecognitionInstructions2ViewController()
            self.navigationController?.pushViewController(vc, animated: true)
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
        if ((answerSegment.selectedSegmentIndex == 0 && practiceAnswers[index] == "S") ||
            (answerSegment.selectedSegmentIndex == 1 && practiceAnswers[index] == "D")) {
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

extension MelodyRecognitionPracticeViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            finishedPlaying()
        }
    }
}
