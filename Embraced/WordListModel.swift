//
//  WordListModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 3/27/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class WordListModel: TestModelProtocol {
    static let shared = WordListModel()
    private let taskAnswers = [1, 3, 8, 11, 13, 14, 15, 16, 17, 26, 30, 33, 35, 38, 40, 41]
    
    var task_1: String?
    var task_2: String?
    var task_3: String?
    var task_4: String?
    var task_5: String?
    var interference: String?
    var shortTerm: String?
    var longTerm: String?
    var answers = [String: Int]()
    var hits: Int = 0
    var commissions: Int = 0
    var omissions: Int = 0
    
    
    private init() {}
    
    func getModel() -> [String: Any] {
        var rv = [String: Any]()
        
        rv["task_1"] = task_1
        rv["task_2"] = task_2
        rv["task_3"] = task_3
        rv["task_4"] = task_4
        rv["task_5"] = task_5

        rv["interference"] = interference
        rv["shortTerm"] = shortTerm
        rv["longTerm"] = longTerm
        
        for (recName, recValue) in answers {
            rv[recName] = recValue
        }
        
        calculateScore()
        
        rv["hits"] = hits
        rv["commissions"] = commissions
        rv["omissions"] = omissions
        
        return rv
    }
    
    func reset() {
        task_1 = ""
        task_2 = ""
        task_3 = ""
        task_4 = ""
        task_5 = ""
        interference = ""
        shortTerm = ""
        longTerm = ""
        answers = [String: Int]()
        hits = 0
        commissions = 0
        omissions = 0
    }
    
    private func calculateScore(){
        for (recName, recValue) in answers {
            let recNameArray = recName.components(separatedBy: "_")
            let index = Int(recNameArray[1])
            
            if (recValue == 0 && taskAnswers.contains(index!) ||
                recValue == 1 && !taskAnswers.contains(index!)) {
                hits += 1
            } else {
                commissions += 1
            }
        }
        
        if answers.count > 0 {
            let totalActions = hits + commissions
            
            if totalActions < 44 {
                omissions = 44 - totalActions
            } else {
                omissions = 0
            }
        }
    }
}
