//
//  CancellationInstructions2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/10/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class CancellationInstructions2ViewController: InstructionsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        navigationItem.hidesBackButton = false
                
        instructionsLabel.text = "cancellation_instructions_2".localized(lang: language)
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
        let vc = CancellationInstructions3ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
