//
//  ClockDrawingModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/3/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class ClockDrawingModel: TestModelProtocol {
    static let shared = ClockDrawingModel()
    
    var file: String?
    var time: Int?
    
    private init() {}
    
    func getModel() -> [String: Any] {
        var rv = [String: Any]()
        
        rv["CLOCK_file"] = file
        rv["CLOCK_time"] = time

        return rv
    }
    
    func reset() {
        file = ""
        time = 0
    }
}
