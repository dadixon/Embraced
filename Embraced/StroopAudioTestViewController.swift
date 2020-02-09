//
//  StroopInstructionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/7/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class StroopAudioTestViewController: AudioPlaybackViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        titleLabel.text = "Practice".localized(lang: language)
        instructionsLabel.text = "AUDIO_VIEW_CONTROLLER_INSTRUCTIONS".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToPreTask", sender: nil)
        let vc = StroopPreTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
