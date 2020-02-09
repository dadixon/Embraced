//
//  MelodyRecognitionInstructionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/6/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class MelodyRecognitionInstructionsViewController: InstructionsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        instructionsLabel.text = "pitch_intro".localized(lang: language)
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToExamples", sender: nil)
        
        let vc = MelodyRecognitionExamplesViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
