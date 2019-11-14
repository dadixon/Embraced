//
//  StroopModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/17/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class StroopModel: TestModelProtocol {
    static let shared = StroopModel()
    
    var file_1: String?
    var file_2: String?
    var file_3: String?
    var file_4: String?
    var rt_1: Int?
    var rt_2: Int?
    var rt_3: Int?
    var rt_4: Int?
    
    private init() {}
    
    func getModel() -> [String: Any] {
        var rv = [String: Any]()
        
        rv["STROOP1_file"] = file_1
        rv["STROOP1_RT"] = rt_1
        rv["STROOP2_file"] = file_2
        rv["STROOP2_RT"] = rt_2
        rv["STROOP3_file"] = file_3
        rv["STROOP3_RT"] = rt_3
        rv["STROOP4_file"] = file_4
        rv["STROOP4_RT"] = rt_4
        
        return rv
    }
    
    func reset() {
        file_1 = ""
        file_2 = ""
        file_3 = ""
        file_4 = ""
        rt_1 = 0
        rt_2 = 0
        rt_3 = 0
        rt_4 = 0
    }
}
