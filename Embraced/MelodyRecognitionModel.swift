//
//  MelodyRecognitionModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/7/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class MelodyRecognitionModel: TestModelProtocol {
    static let shared = MelodyRecognitionModel()
    
    private var score: Int = 0
    var answers = [String: Any]()
    
    private init() {}
    
    func getModel() -> [String: Any] {
        calculateScore()
        answers["score"] = score
        
        return answers
    }
    
    func reset() {
        score = 0
        answers = [String: Any]()
    }
    
    private func calculateScore() {
        for answer in answers {
            if answer.value as! String == "c" {
                score += 1
            }
        }
    }
}
