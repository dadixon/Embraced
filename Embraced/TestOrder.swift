//
//  TestOrder.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/15/17.
//  Copyright © 2017 Domonique Dixon. All rights reserved.
//

import Foundation
import UIKit

final class TestOrder {
    static let sharedInstance = TestOrder()
    private let userDefaults = UserDefaults.standard
    private var navigationTests = [UIViewController]()
    
    private init() {
        
    }

    func clearTests() {
        navigationTests.removeAll()
    }
    
    func setTests() {
        var tests = [String]()
        
        if let test = userDefaults.array(forKey: "Tests"), userDefaults.array(forKey: "Tests")?.count != 0 {
            tests = test as! [String]
            
        userDefaults.set(tests, forKey: "Tests")
        TestConfig.shared.testListName = tests
            
        for test in tests {
            switch test {
            case "Questionnaire":
                navigationTests.append(QuestionnaireViewController())
            case "Orientation Task":
                navigationTests.append(MOCAMMSETestViewController())
            case "Complex Figure 1":
                navigationTests.append(ReyComplexFigureViewController())
//            case "Clock Drawing Test":
//                navigationTests.append(ClockDrawingTestViewController())
            case "Complex Figure 2":
                navigationTests.append(ReyComplexFigure2ViewController())
            case "Trail Making Test":
                navigationTests.append(TrailMakingTestViewController())
//            case "Melodies Recognition":
//                navigationTests.append(PitchViewController())
//            case "Digit Span":
//                navigationTests.append(DigitalSpanViewController())
            case "Complex Figure 3":
                navigationTests.append(ReyComplexFigure3ViewController())
            case "Complex Figure 4":
                navigationTests.append(ReyFigureComplex4ViewController())
            case "Matrices":
                navigationTests.append(MatricesViewController())
            case "Continuous Performance Test":
                navigationTests.append(CPTViewController())
            case "Motor Tasks":
                navigationTests.append(PegboardViewController())
            case "Word List 1":
                if TestConfig.shared.testList.count > 0 {
                    TestConfig.shared.testStartTime = CFAbsoluteTimeGetCurrent()
                    //self.navigationController?.pushViewController(TestConfig.sharedInstance.testList[0], animated: true)
                    navigationTests.append(TestConfig.shared.testList[0])
                } else {
//                    navigationTests.append(WordListViewController())
                }
//            case "Color-Word Stroop Test":
//                navigationTests.append(StroopViewController())
//            case "Cancellation Test":
//                navigationTests.append(CancellationTestViewController())
//            case "Word List 2":
//                navigationTests.append(WordList2ViewController())
//            case "Naming Test":
//                navigationTests.append(NamingTaskViewController())
            case "Comprehension Task":
                navigationTests.append(ComprehensionViewController())
            case "Eyes Test":
                navigationTests.append(EyeTestViewController())
            default:
                navigationTests.append(UserInputViewController())
            }
        }
        
//        navigationTests.append(FinishedViewController())
        }
    }
    
    func addTest(viewController: UIViewController, at: Int) {
        navigationTests.insert(viewController, at: at)
    }
    
    func getTest(_ at: Int) -> UIViewController {
        return navigationTests[at]
    }
    
    func getTests() -> [UIViewController] {
        return navigationTests
    }
}
