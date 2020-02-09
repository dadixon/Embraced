//
//  TrailMakingVideoViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/3/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class TrailMakingVideoViewController: ActiveStepViewController {

    let videoView: WKYTPlayerView = {
        var view = WKYTPlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .portrait
        rotateOrientation = .portrait
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        setupViews()
        
        videoView.load(withVideoId: "uo8n-vMlpGA")
    }
    
    private func setupViews() {
        contentView.addSubview(videoView)
        
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 75.0).isActive = true
        
        videoView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        videoView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        videoView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        videoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        contentView.layer.backgroundColor = UIColor.blue.cgColor
    }
    
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToTask", sender: nil)
        let vc = TrailMakingTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
