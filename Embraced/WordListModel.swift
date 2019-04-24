//
//  WordListModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 3/27/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class WordListModel {
    static let shared = WordListModel()
    
    var task_1: String?
    var task_2: String?
    var task_3: String?
    var task_4: String?
    var task_5: String?
    var interference: String?
    var shortTerm: String?
    var longTerm: String?
    var questions: [[String: Bool]]? = []
    
    private init() {}
    
    func printModel() -> [String: Any] {
        var rv = [String: Any]()
        
        rv["task_1"] = task_1
        rv["task_2"] = task_2
        rv["task_3"] = task_3
        rv["task_4"] = task_4
        rv["task_5"] = task_5

        rv["interference"] = interference
        rv["shortTerm"] = shortTerm
        rv["longTerm"] = longTerm
        
        if let listQuestions = questions {
            for question in listQuestions {
                var keys = Array(question.keys)
                rv[keys[0]] = question[keys[0]]
            }
        }
        
        return rv
    }
}
