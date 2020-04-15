//
//  QuestionnaireModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 3/2/20.
//  Copyright © 2020 Domonique Dixon. All rights reserved.
//

import Foundation

class QuestionnaireModel: TestModelProtocol {
    static let shared = QuestionnaireModel()
    
    private var age: Int?
    var dob: Date?
    var gender: String?
    
    private init() {}
    
    func getModel() -> [String : Any] {
        var rv = [String: Any]()
        
        rv["Assesment"] = Date()
        rv["DOB"] = dob
        rv["age"] = calculateAge(dob: dob!)
        rv["gender"] = gender
        
        return rv
    }
    
    func reset() {
        dob = nil
        gender = nil
    }
    
    private func calculateAge(dob: Date) -> Int {
        return 0
    }
}
