//
//  EyesTaskDoneViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/13/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class EyesTaskDoneViewController: DoneStepViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .portrait
        rotateOrientation = .portrait
        
        FirebaseStorageManager.shared.addDataToDocument(payload: [
            "eyeTest" : EyeTestModel.shared.getModel()
        ])
    }
}
