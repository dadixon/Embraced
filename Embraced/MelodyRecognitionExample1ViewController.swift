//
//  MelodyRecognitionExample1ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/6/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class MelodyRecognitionExample1ViewController: ActiveStepViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        titleLabel.text = "Example 1"
        instructionsLabel.text = """
        In this pair of melodies the second melody is identical to the first.
        When both melodies are the same, you should tap the button “SAME”
        Tap on the button “SAME” to indicate that the melodies are the same.
        """
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        title = "Step 2 of 3"
    }
    
    @objc func moveOn() {
        self.performSegue(withIdentifier: "moveToDone", sender: self)
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
