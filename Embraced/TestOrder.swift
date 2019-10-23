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
