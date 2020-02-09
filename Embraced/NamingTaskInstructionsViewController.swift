//
//  NamingTaskInstructionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/29/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class NamingTaskInstructionsViewController: InstructionsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        titleLabel.text = "Practice".localized(lang: language)
        instructionsLabel.text = "naming_practice_instruction2".localized(lang: language)
        
        nextBtn.setTitle("Start".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToPractice", sender: nil)
        let vc = NamingTaskPracticeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
