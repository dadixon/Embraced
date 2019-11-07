//
//  MotorInstructions2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/6/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class MotorInstructions2ViewController: InstructionsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        instructionsLabel.text = "motor_2_instructions".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
        self.performSegue(withIdentifier: "moveToTask3", sender: nil)
    }

}
