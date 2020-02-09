//
//  StroopInstructionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/7/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class StroopInstructionsViewController: InstructionsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        instructionsLabel.text = "stroop_ptask".localized(lang: language)
        
        nextBtn.setTitle("Start".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToTask", sender: nil)
        let vc = StroopTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
