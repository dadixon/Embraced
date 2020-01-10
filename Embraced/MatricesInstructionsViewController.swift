//
//  MatricesInstructionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/9/20.
//  Copyright © 2020 Domonique Dixon. All rights reserved.
//

import UIKit

class MatricesInstructionsViewController: InstructionsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .portrait
        rotateOrientation = .portrait
                
        instructionsLabel.text = "matricesTask_instructions".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
        
    @objc func moveOn() {
        self.performSegue(withIdentifier: "moveToTask", sender: nil)
    }

}
