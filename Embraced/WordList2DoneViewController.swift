//
//  WordList2DoneViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/3/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class WordList2DoneViewController: DoneStepViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        FirebaseStorageManager.shared.addDataToDocument(payload: [
            "wordList": WordListModel.shared.getModel()
        ])
    }

}
