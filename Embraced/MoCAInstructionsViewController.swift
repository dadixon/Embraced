//
//  MoCAInstructionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 3/26/20.
//  Copyright © 2020 Domonique Dixon. All rights reserved.
//

import UIKit

class MoCAInstructionsViewController: InstructionsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .portrait
        rotateOrientation = .portrait
        
        instructionsLabel.text = "moca_instructions".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
        let vc = MoCATaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
