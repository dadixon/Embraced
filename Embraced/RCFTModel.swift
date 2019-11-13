//
//  RCFTModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/3/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class RCFTModel: TestModelProtocol {
    static let shared = RCFTModel()
    
    var file_1: String?
    var file_2: String?
    var file_3: String?
    var time_1: Int?
    var time_2: Int?
    var time_3: Int?
    var answers = [String: Bool]()
    
    private init() {}
    
    func getModel() -> [String: Any] {
        var rv = [String: Any]()
        
        rv["RCFT_time_1"] = time_1
        rv["RCFT_file_1"] = file_1
        rv["RCFT_time_2"] = time_2
        rv["RCFT_file_2"] = file_2
        rv["RCFT_time_3"] = time_3
        rv["RCFT_file_3"] = file_3
        
        for answer in answers {
            rv["RCFT_question_\(answer.key)"] = answer.value
        }
        
        return rv
    }
    
    func reset() {
        file_1 = ""
        file_2 = ""
        file_3 = ""
        time_1 = 0
        time_2 = 0
        time_3 = 0
        answers = [String: Bool]()
    }
}
