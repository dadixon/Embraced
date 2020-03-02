//
//  WordListInstructionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 4/10/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class WordListInstructionsViewController: AudioPlaybackViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        titleLabel.text = "Practice".localized(lang: language)
        instructionsLabel.text = "wordlist1_practice_instruction".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
        let vc = WordListTrialsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
