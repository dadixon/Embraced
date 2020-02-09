//
//  StroopPreTaskViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/7/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import AVKit

class StroopPreTaskViewController: ActiveStepViewController, AVPlayerViewControllerDelegate {

    let index = 0
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
        print("Play Video")
        playVideoFile(filename: videoPath)
    }
    
    private func playVideoFile(filename: String) {
        guard let path = Bundle.main.path(forResource: filename, ofType: nil) else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        player = AVPlayer(url: url)
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
        
//        self.performSegue(withIdentifier: "moveToInstructions", sender: nil)
        let vc = StroopInstructionsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
