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
    static var testListCount: Int = 0
    
    private init() {}
    
    private func buildTestList() {
        testList = []
        
        for test in testListName {
            switch test {
                case "Questionnaire":
                    let vc = MonthViewController()
                    self.testList.append(vc)
                case "Orientation Task":
                    let vc = MoCAViewController()
                    self.testList.append(vc)
                case "Melodies Recognition":
                    let vc = MelodyRecognitionInstructionsViewController()
                    self.testList.append(vc)
                case "Word List 1":
                    let vc = WordListInstructionsViewController()
                    self.testList.append(vc)
                case "Cancellation Test":
                    let vc = CancellationInstructionsViewController()
                    self.testList.append(vc)
                case "Digit Span":
                    let vc = DigitSpanInstructionsViewController()
                    self.testList.append(vc)
                case "Color-Word Stroop Test":
                    let vc = StroopAudioTestViewController()
                    self.testList.append(vc)
                case "Naming Test":
                    let vc = NamingTaskAudioTestViewController()
                    self.testList.append(vc)
                case "Word List 2":
                    let vc = WordList2TaskViewController()
                    self.testList.append(vc)
                case "Clock Drawing Test":
                    let vc = ClockDrawingInstructionsViewController()
                    self.testList.append(vc)
                case "Complex Figure 1":
                    let vc = RCFTInstructionsViewController()
                    self.testList.append(vc)
                case "Complex Figure 2":
                    let vc = RCFT2InstructionsViewController()
                    self.testList.append(vc)
                case "Complex Figure 3":
                    let vc = RCFT3InstructionsViewController()
                    self.testList.append(vc)
                case "Trail Making Test":
                    let vc = TrailMakingInstructionsViewController()
                    self.testList.append(vc)
                case "Complex Figure 4":
                    let vc = RCFT4InstructionsViewController()
                    self.testList.append(vc)
                case "Comprehension Task":
                    let vc = ComprehensionTaskInstructionViewController()
                    self.testList.append(vc)
                case "Motor Tasks":
                    let vc = MotorInstructionsViewController()
                    self.testList.append(vc)
                case "Eyes Test":
                    let vc = EyesTaskInstructionViewController()
                    self.testList.append(vc)
                case "Matrices":
                    let vc = MatricesInstructionsViewController()
                    self.testList.append(vc)
                case "Continuous Performance Test":
                    let vc = CPTTaskViewController()
                    self.testList.append(vc)
                default:
                    continue
            }
        }
        
        TestConfig.testListCount = self.testList.count
    }
}
