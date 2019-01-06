//
//  MelodyRecognitionInstructionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/6/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class MelodyRecognitionInstructionsViewController: InstructionsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionsLabel.text = """
        Next, you will hear pairs of melodies.
        In some trials, the second one will be altered.
        This change may be subtle or obvious.
        
        You will have to indicate whether the second melody has been altered or not.
        If both melodies are the same, you will tap the button “SAME”
        If they are different, you will tap the button “DIFFERENT”
        
        To aid you differentiate the two melodies, numbers 1 and 2 will be shown in the screen when playing the first and second melody respectively
        
        We will start with some examples.
        Please tap on START when you are ready.
        """
        
        nextBtn.setTitle("Next", for: .normal)
        
        title = "Step 1 of 3"
        
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
    }
    
    @objc func moveOn() {
        self.performSegue(withIdentifier: "moveToExample1", sender: nil)
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
