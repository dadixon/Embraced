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
                case "Digit Span":
                    if let vc = UIStoryboard(name: "DigitSpan", bundle: nil).instantiateViewController(withIdentifier: "DigitSpanTest") as? DigitSpanInstructionsViewController {
                        self.testList.append(vc)
                    }
                case "Color-Word Stroop Test":
                    if let vc = UIStoryboard(name: "Stroop", bundle: nil).instantiateViewController(withIdentifier: "StroopTest") as? StroopAudioTestViewController {
                        self.testList.append(vc)
                    }
                case "Naming Test":
                    if let vc = UIStoryboard(name: "NamingTask", bundle: nil).instantiateViewController(withIdentifier: "NamingTest") as? NamingTaskAudioTestViewController {
                        self.testList.append(vc)
                    }
                case "Word List 2":
                    if let vc = UIStoryboard(name: "WordList2", bundle: nil).instantiateViewController(withIdentifier: "WordList2Test") as? WordList2TaskViewController {
                        self.testList.append(vc)
                    }
                case "Clock Drawing Test":
                    if let vc = UIStoryboard(name: "ClockDrawing", bundle: nil).instantiateViewController(withIdentifier: "ClockDrawingTest") as? ClockDrawingInstructionsViewController {
                        self.testList.append(vc)
                    }
                case "Complex Figure 1":
                    if let vc = UIStoryboard(name: "RCFT", bundle: nil).instantiateViewController(withIdentifier: "RCFTTest") as? RCFTInstructionsViewController {
                        self.testList.append(vc)
                    }
                case "Complex Figure 2":
                    if let vc = UIStoryboard(name: "RCFT2", bundle: nil).instantiateViewController(withIdentifier: "RCFT2Test") as? RCFT2InstructionsViewController {
                        self.testList.append(vc)
                    }
                case "Complex Figure 3":
                    if let vc = UIStoryboard(name: "RCFT3", bundle: nil).instantiateViewController(withIdentifier: "RCFT3Test") as? RCFT3InstructionsViewController {
                        self.testList.append(vc)
                    }
                case "Trail Making Test":
                    if let vc = UIStoryboard(name: "TrailMaking", bundle: nil).instantiateViewController(withIdentifier: "TrailMakingTest") as? TrailMakingInstructionsViewController {
                        self.testList.append(vc)
                    }
                case "Complex Figure 4":
                    if let vc = UIStoryboard(name: "RCFT4", bundle: nil).instantiateViewController(withIdentifier: "RCFT4Test") as? RCFT4InstructionsViewController {
                        self.testList.append(vc)
                    }
                default:
                    continue
            }
        }
    }
}
