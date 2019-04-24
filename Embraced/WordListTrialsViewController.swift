//
//  WordListTrialsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 4/19/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class WordListTrialsViewController: ActiveStepViewController {

    var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .landscape
        
        titleLabel.text = "Trial".localized(lang: language) + " \(index)"
        instructionsLabel.text = "wordlist1_instructionA1".localized(lang: language)
    }
}
