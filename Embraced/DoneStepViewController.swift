//
//  DoneStepViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/22/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class DoneStepViewController: ActiveStepViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "Test_complete".localized(lang: language)
        
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        if TestConfig.shared.testList.count > 1 {
            nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        } else {
            nextBtn.setTitle("Done".localized(lang: language), for: .normal)
        }
    }
    
    @objc func moveOn() {
        TestConfig.shared.testList.remove(at: 0)
        TestConfig.testIndex += 1
        
        if TestConfig.shared.testList.count > 0 {
            navigationController?.pushViewController(TestConfig.shared.testList[0], animated: true)
        } else {
            TestConfig.shared.testEndTime = CFAbsoluteTimeGetCurrent()
            
            TestConfig.testIndex = 1
            TestConfig.shared.testList = [];
            AppDelegate.position = 0
            AppDelegate.testPosition = 0
            FirebaseStorageManager.shared.addDataToDocument(payload: [
                "time": Int((TestConfig.shared.testEndTime! - TestConfig.shared.testStartTime!) * 1000),
            ])
            
            TestOrder.sharedInstance.clearTests()
            
            self.dismiss(animated: true) {}
        }
    }

}
