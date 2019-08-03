//
//  DigitSpanInstructionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/8/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class DigitSpanInstructionsViewController: AudioPlaybackViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .portrait
        rotateOrientation = .portrait
        
        titleLabel.text = "Practice".localized(lang: language)
        instructionsLabel.text = "digital_practice_1".localized(lang: language)
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
        self.performSegue(withIdentifier: "moveToPractice", sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
