//
//  StroopInstructions3ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/25/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class StroopInstructions3ViewController: InstructionsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        instructionsLabel.text = "stroop_ptask".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToTask2", sender: nil)
        let vc = StroopTask2ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
