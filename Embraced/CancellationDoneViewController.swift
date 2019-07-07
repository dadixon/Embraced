//
//  CancellationDoneViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/22/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class CancellationDoneViewController: DoneStepViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        FirebaseStorageManager.shared.addDataToDocument(payload: [
            "cancellation": CancellationModel.shared.printModel()
        ])
    }
}
