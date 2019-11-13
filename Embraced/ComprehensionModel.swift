//
//  ComprehensionModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/17/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class ComprehensionModel: TestModelProtocol {
    static let shared = ComprehensionModel()
    
    var answers = [String: [Int]]()
    var reactionTimes = [String: Int]()
        
    private init() {}
    
    func getModel() -> [String: Any] {
        var rv = [String: Any]()
        
        for answer in answers {
            rv["COMPREHENSION_\(answer.key)"] = answer.value
        }
        
        for reaction in reactionTimes {
            rv["COMPREHENSION_\(reaction.key)_RT"] = reaction.value
        }
        
        rv["COMPREHENSION_AVG_RT"] = calculateAverage()
        rv["COMPREHENSION_total"] = calculateCorrectAnswers()
        
        return rv
    }
    
    func reset() {
        answers = [String: [Int]]()
        reactionTimes = [String: Int]()
    }
    
    private func calculateAverage() -> Double {
        var total = 0
        
        for reaction in reactionTimes {
            total += reaction.value
        }
        
        return Double(total / reactionTimes.count)
    }
    
    private func calculateCorrectAnswers() -> Int {
        var total = 0
        
        for answer in answers {
            switch answer.key {
            case "1":
                if singleTrue(answers: answer.value, keys: [1, 4, 15, 20]) {
                    total += 1
                }
            case "2":
                if singleTrue(answers: answer.value, keys: [10, 11, 12, 14]) {
                    total += 1
                }
            case "3":
                if singleTrue(answers: answer.value, keys: [5, 7, 3, 16, 19]) {
                    total += 1
                }
            case "4":
                if singleTrue(answers: answer.value, keys: [11, 14]) {
                    total += 1
                }
            case "5":
                if singleTrue(answers: answer.value, keys: [15, 18]) {
                    total += 1
                }
            case "6":
                if singleTrue(answers: answer.value, keys: [16]) {
                    total += 1
                }
            case "7":
                if singleTrue(answers: answer.value, keys: [2, 18]) {
                    total += 1
                }
            case "8":
                if singleTrue(answers: answer.value, keys: [15, 17]) {
                    total += 1
                }
            case "9":
                if singleTrue(answers: answer.value, keys: [15]) {
                    total += 1
                }
            case "10":
                if singleTrue(answers: answer.value, keys: [4]) {
                    total += 1
                }
            case "11":
                if singleTrue(answers: answer.value, keys: [10]) {
                    total += 1
                }
            case "12":
                if singleTrue(answers: answer.value, keys: [9]) {
                    total += 1
                }
            case "13":
                if multipleTrue(answers: answer.value, keys: [6, 8, 9]) {
                    total += 1
                }
            case "14":
                if multipleTrue(answers: answer.value, keys: [1,7, 13, 19]) {
                    total += 1
                }
            case "15":
                if multipleTrue(answers: answer.value, keys: [11, 14]) {
                    total += 1
                }
            case "16":
                if multipleTrue(answers: answer.value, keys: [10, 12, 18]) {
                    total += 1
                }
            case "17":
                if multipleTrue(answers: answer.value, keys: [4, 6, 8, 20]) {
                    total += 1
                }
            case "18":
                if singleTrue(answers: answer.value, keys: [15]) {
                    total += 1
                }
            case "19":
                if singleTrue(answers: answer.value, keys: [18]) {
                    total += 1
                }
            case "20":
                if multipleTrue(answers: answer.value, keys: [4, 16, 20]) {
                    total += 1
                }
            case "21":
                if multipleTrue(answers: answer.value, keys: [6, 8, 10, 12, 14]) {
                    total += 1
                }
            default:
                break
            }
        }
        
        return total
    }
    
    private func singleTrue(answers: [Int], keys: [Int]) -> Bool {
        for key in keys {
            if answers.contains(key) {
                return true
            }
        }
        
        return false
    }
    
    private func multipleTrue(answers: [Int], keys: [Int]) -> Bool {
        for key in keys {
            if !answers.contains(key) {
                return false
            }
        }
        
        return true
    }
}
