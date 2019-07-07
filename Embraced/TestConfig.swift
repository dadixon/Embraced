//
//  TestConfig.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/7/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation
import UIKit

class TestConfig {
    static let shared = TestConfig()
    
    var testListName = [String]() {
        didSet {
            buildTestList()
        }
    }
    
    var testList = [UIViewController]()
    var testStartTime: CFAbsoluteTime?
    var testEndTime: CFAbsoluteTime?
    static var testIndex: Int = 1
    
    private init() {}
    
    private func buildTestList() {
        testList = []
        
        for test in testListName {
            switch test {
                case "Melodies Recognition":
                    if let vc = UIStoryboard(name: "MelodyRecognition", bundle: nil).instantiateViewController(withIdentifier: "MelodyRecognitionTest") as? MelodyRecognitionInstructionsViewController {
                        self.testList.append(vc)
                    }
                case "Word List 1":
                    if let vc = UIStoryboard(name: "WordList", bundle: nil).instantiateViewController(withIdentifier: "WordListTest") as? WordListInstructionsViewController {
                        self.testList.append(vc)
                    }
                case "Cancellation Test":
                    if let vc = UIStoryboard(name: "Cancellation", bundle: nil).instantiateViewController(withIdentifier: "CancellationTest") as? CancellationInstructionsViewController {
                        self.testList.append(vc)
                    }
                default:
                    continue
            }
        }
    }
}
