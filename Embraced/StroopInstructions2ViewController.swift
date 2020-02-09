//
//  StroopInstructions2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/25/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class StroopInstructions2ViewController: InstructionsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        instructionsLabel.text = "stroop_practice_instruction2".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToPreTask2", sender: nil)
        let vc = StroopPreTask2ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
