//
//  MotorModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/1/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class MotorModel: TestModelProtocol {
    static let shared = MotorModel()
    
    var dominants = [String: String]()
    var nondominants = [String: String]()
    
    private init() {}
    
    func getModel() -> [String: Any] {
        var rv = [String: Any]()
        
        for dominant in dominants {
            rv["MOTOR_\(dominant.key)_dominant_file"] = dominant.value
            rv["MOTOR_\(dominant.key)_dominant_score"] = ""
        }
        
        for nondominant in nondominants {
            rv["MOTOR_\(nondominant.key)_nondominant_file"] = nondominant.value
            rv["MOTOR_\(nondominant.key)_nondominant_score"] = ""
        }
        
        return rv
    }
    
    func reset() {
        dominants = [String: String]()
        nondominants = [String: String]()
    }
}
