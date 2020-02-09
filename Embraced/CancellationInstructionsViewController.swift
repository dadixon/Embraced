//
//  CancellationInstructionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/10/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class CancellationInstructionsViewController: InstructionsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        instructionsLabel.text = "cancellation_instructions_1".localized(lang: language)
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToInstructions2", sender: nil)
        let vc = CancellationInstructionsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
