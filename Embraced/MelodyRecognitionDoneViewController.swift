//
//  MelodyRecognitionDoneViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/8/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class MelodyRecognitionDoneViewController: DoneStepViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseStorageManager.shared.addDataToDocument(payload: [
            "melodyRecognition": MelodyRecognitionModel.shared.printModel()
        ])
    }
}
