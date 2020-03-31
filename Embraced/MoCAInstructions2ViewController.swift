//
//  MoCAInstructions2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 3/26/20.
//  Copyright © 2020 Domonique Dixon. All rights reserved.
//

import UIKit

class MoCAInstructions2ViewController: InstructionsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .portrait
            rotateOrientation = .portrait
            
            instructionsLabel.text = "moca_instructions_2".localized(lang: language)
            
            nextBtn.setTitle("Next".localized(lang: language), for: .normal)
            nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        }
        
        @objc func moveOn() {
            let vc = MoCATask2ViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }

}
