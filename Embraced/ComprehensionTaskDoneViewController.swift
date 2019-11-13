//
//  ComprehensionTaskDoneViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/17/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class ComprehensionTaskDoneViewController: DoneStepViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .portrait
        rotateOrientation = .portrait
        
        FirebaseStorageManager.shared.addDataToDocument(payload: [
            "comprehension": ComprehensionModel.shared.getModel()
        ])
    }

}
