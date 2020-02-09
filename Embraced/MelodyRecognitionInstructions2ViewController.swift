//
//  MelodyRecognitionInstructions2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/5/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class MelodyRecognitionInstructions2ViewController: InstructionsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        instructionsLabel.text = "pitch_instructions".localized(lang: language)
        nextBtn.setTitle("Start".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    

    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToTask", sender: nil)
        let vc = MelodyRecognitionTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
