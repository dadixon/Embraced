//
//  EyeTestModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/13/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class EyeTestModel: TestModelProtocol {
    static let shared = EyeTestModel()
    
    var answers = [Int]()
    
    private let answerKey = [
        4, 1, 3, 3, 4, 3, 1, 1, 4, 4, 1, 4, 1, 4, 4, 4, 1, 4, 3, 3, 1, 2, 1, 4, 1, 3, 4, 2, 3, 4, 1, 3, 4, 1, 4, 1, 1
    ]
    private var totalCorrect = 0
    
    private init() {}
    
    func getModel() -> [String: Any] {
        var rv = [String: Any]()
        
        for i in 0..<answers.count {
            let isCorrect = answerKey[i] == answers[i]
            
            if i == 0 {
                rv["EYES_Practice_answer"] = answers[i]
                rv["EYES_Practice_correct"] = isCorrect
            } else {
                rv["EYES_\(i)_answer"] = answers[i]
                rv["EYES_\(i)_correct"] = isCorrect
                
                if isCorrect {
                    totalCorrect += 1
                }
            }
        }
        
        rv["EYES_total"] = totalCorrect
        
        return rv
    }
    
    func reset() {
        answers = [Int]()
        totalCorrect = 0
    }
}
