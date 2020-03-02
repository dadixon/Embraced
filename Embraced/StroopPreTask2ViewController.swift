//
//  StroopPreTask2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/25/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import AVKit

class StroopPreTask2ViewController: ActiveStepViewController, AVPlayerViewControllerDelegate {
    
    let index = 1
    var imagePath = ""
    var videoPath = ""
    var previewBtnWidth: NSLayoutConstraint?
    var playerController = AVPlayerViewController()
    var player = AVPlayer()
    var videoLayer = AVPlayerLayer()
    
    let videoView: UIView = {
        var view = UIView()
        view.layer.backgroundColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let previewBtn: UIButton = {
        var button = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(previewPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        instructionsLabel.text = "stroop_pretask_instruction".localized(lang: language)
        
        previewBtn.setTitle("Preview".localized(lang: language), for: .normal)
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        imagePath = DataManager.sharedInstance.stroopTasks[index]
        videoPath = DataManager.sharedInstance.stroopVideos[index]
        
        setupView()
    }
    
    private func setupView(){
        contentView.addSubview(videoView)
        contentView.addSubview(previewBtn)
        
        videoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0).isActive = true
        videoView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0).isActive = true
        videoView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0).isActive = true
        videoView.bottomAnchor.constraint(equalTo: previewBtn.topAnchor, constant: -16.0).isActive = true
        
        previewBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
        previewBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        previewBtn.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        previewBtnWidth = previewBtn.widthAnchor.constraint(equalToConstant: previewBtn.intrinsicContentSize.width + 100.0)
        previewBtnWidth?.isActive = true
    }
    
    @objc func previewPressed() {
        playVideoFile(fileName: "stroop/\(language)/\(videoPath)")
    }
    
    private func playVideoFile(fileName: String) {
        let filePath = Utility.getAudio(path: fileName)
        
        player = AVPlayer(url: filePath)
        player.actionAtItemEnd = .none
        
        playerController.delegate = self
        playerController.player = player
        videoLayer = AVPlayerLayer(player: player)
        
        videoLayer.frame = videoView.bounds
        videoView.layer.addSublayer(videoLayer)
        
        player.play()
    }
    
    @objc func moveOn() {
        player.pause()
        videoLayer.player = nil
        
//        self.performSegue(withIdentifier: "moveToInstructions3", sender: nil)
        let vc = StroopInstructions3ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
