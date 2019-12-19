//
//  MatricesModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/12/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class MatricesModel: TestModelProtocol {
    static let shared = MatricesModel()
    
    private var score = 0
    var answers = [String: Int]()
    let answerKey = [
        [4, 5, 2, 3, 6, 1, 2, 6, 1, 3, 4, 2]
    ]
    
    private init() {}
    
    func getModel() -> [String : Any] {
        var rv = [String: Any]()
        var totalCorrect = 0
        
        for answer in answers {
            let checkCorrectAnswer = checkAnswer(key: String(answer.key.prefix(1)), index: Int(String(answer.key.suffix(1)))!, value: answer.value)
            
            rv["MATRICES\(answer.key)_answer"] = answer.value
            rv["MATRICES\(answer.key)_correct"] = checkCorrectAnswer
            
            totalCorrect = totalCorrect + checkCorrectAnswer
        }
        
        rv["MATRICES_totalCorrect"] = totalCorrect
        
        return rv
    }
    
    func reset() {
        score = 0
        answers = [String: Int]()
    }
    
    private func checkAnswer(key: String, index: Int, value: Int) -> Int {
        switch key {
        case "A":
            if answerKey[0][index - 1] == value {
                return 1
            }
        default: break
            
        }
        return 0
    }
}
