//
//  TrailMakingModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/5/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class TrailMakingModel: TestModelProtocol {
    static let shared = TrailMakingModel()
    
    var file_1: String?
    var file_2: String?
    var time_1: Int?
    var time_2: Int?
    
    private init() {}
    
    func getModel() -> [String: Any] {
        var rv = [String: Any]()
        
        rv["TMTA_file_1"] = file_1
        rv["TMTA_time_1"] = time_1
        rv["TMTA_file_2"] = file_2
        rv["TMTA_time_2"] = time_2
        
        return rv
    }
    
    func reset() {
        file_1 = ""
        file_2 = ""
        time_1 = 0
        time_2 = 0
    }
}
