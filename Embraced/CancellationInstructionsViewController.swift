//
//  CancellationInstructionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/10/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class CancellationInstructionsViewController: InstructionsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionsLabel.text = "cancellation_instructions_1".localized(lang: language)
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        
        title = "Step 1 of 3"
        
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
        self.performSegue(withIdentifier: "moveToInstructions2", sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
