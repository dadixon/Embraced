//
//  CancellationInstructions3ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/10/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class CancellationInstructions3ViewController: InstructionsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        navigationItem.hidesBackButton = false
        
        instructionsLabel.text = "cancellation_instructions_3".localized(lang: language)
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToPractice", sender: nil)
        let vc = CancellationPracticeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
