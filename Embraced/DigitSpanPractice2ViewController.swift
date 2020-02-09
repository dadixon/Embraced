//
//  DigitSpanPractice2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/6/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class DigitSpanPractice2ViewController: ActiveStepViewController {

    var backwardPractice = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .portrait
        rotateOrientation = .portrait
        
        instructionsLabel.text = "digital_practice_3".localized(lang: language)
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        backwardPractice = DataManager.sharedInstance.digitalSpanBackwardPractice
    }
    
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToTask2", sender: nil)
        let vc = DigitSpanTask2ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
