//
//  RCFTInstructions2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/3/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class RCFTInstructions2ViewController: InstructionsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        instructionsLabel.text = "rcft_1_instructions_3".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToTask", sender: nil)
        let vc = RCFTTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
