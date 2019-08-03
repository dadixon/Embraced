//
//  WordList2RecognitionViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/3/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation

class WordList2RecognitionViewController: ActiveStepViewController {

    var index = 0
    var audioPlayer: AVAudioPlayer!
    var soundPath = ""
    var tasks = [String]()
    
    let confirmationLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
//        label.font = UIFont.boldSystemFont(ofSize: 36.0)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        titleLabel.text = "Recognition".localized(lang: language)
        instructionsLabel.text = "wordlist2_instruction2".localized(lang: language)
        confirmationLabel.text = "wordlist2_in_first_list".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        tasks = DataManager.sharedInstance.wordListRecognitions
        
        answerSegment.setTitle("Yes".localized(lang: language), forSegmentAt: 0)
        answerSegment.setTitle("No".localized(lang: language), forSegmentAt: 1)
        
        setupView()
        setState()
    }
    
    private func setupView() {
        contentView.addSubview(playBtn)
        contentView.addSubview(confirmationLabel)
        contentView.addSubview(answerSegment)
        
        playBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        playBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 165.0).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 165.0).isActive = true
        
        confirmationLabel.topAnchor.constraint(equalTo: playBtn.bottomAnchor, constant: 16.0).isActive = true
        confirmationLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        confirmationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0).isActive = true
        confirmationLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0).isActive = true
        
        answerSegment.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        answerSegment.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        answerSegment.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        answerSegment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
    }
    
    private func setState() {
        soundPath = tasks[index]
        playBtn.isEnabled = true
        answerSegment.isHidden = true
        answerSegment.selectedSegmentIndex = UISegmentedControl.noSegment
        answerSegment.isEnabled = true
        nextBtn.isHidden = true
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
        answerSegment.isHidden = false
    }
    
    @objc func playPressed() {
        playAudio(fileName: soundPath)
        playBtn.isEnabled = false
    }
    
    @objc func segmentPressed() {
        nextBtn.isHidden = false
        answerSegment.isEnabled = false
        WordListModel.shared.answers["rec_\(index + 1)"] = answerSegment.selectedSegmentIndex
    }
    
    @objc func moveOn() {
        index += 1
        
        if index == tasks.count {
            self.performSegue(withIdentifier: "moveToDone", sender: nil)
        } else {
            setState()
        }
    }
}

extension WordList2RecognitionViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            finishedPlaying()
        }
    }
}
