//
//  RCFT4InstructionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/23/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class RCFT4InstructionsViewController: InstructionsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .portrait
        rotateOrientation = .portrait
        
        instructionsLabel.text = "rcft_4_instructions".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToTask", sender: nil)
        let vc = RCFT4TaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
