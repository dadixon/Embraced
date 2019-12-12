//
//  MatricesDoneViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/12/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class MatricesDoneViewController: DoneStepViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .portrait
        rotateOrientation = .portrait
        
        FirebaseStorageManager.shared.addDataToDocument(payload: [
            "matricesTest" : MatricesModel.shared.getModel()
        ])
    }

}
