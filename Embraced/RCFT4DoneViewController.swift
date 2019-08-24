//
//  RCFT4DoneViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/23/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class RCFT4DoneViewController: DoneStepViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .portrait
        rotateOrientation = .portrait
        
        FirebaseStorageManager.shared.addDataToDocument(payload: [
            "rcft": RCFTModel.shared.printModel()
        ])
    }
}
