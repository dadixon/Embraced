//
//  CancellationInstructions2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/10/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class CancellationInstructions2ViewController: InstructionsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = false
                
        instructionsLabel.text = "cancellation_instructions_2".localized(lang: language)
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        
        title = "Step 2 of 3"
        
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
        self.performSegue(withIdentifier: "moveToInstructions3", sender: nil)
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
