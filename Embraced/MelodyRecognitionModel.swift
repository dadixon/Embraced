//
//  MelodyRecognitionModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/7/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class MelodyRecognitionModel {
    static let sharedInstance = MelodyRecognitionModel()
    
    var score: Int = 0
    var answers = [String: Any]()
    
    private init() {}
    
    func printModel() -> [String: Any] {
        calculateScore()
        answers["score"] = score
        
        return answers
    }
    
    private func calculateScore(){
        for answer in answers {
            if answer.value as! String == "c" {
                score += 1
            }
        }
    }
}
