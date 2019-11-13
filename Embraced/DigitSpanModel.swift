//
//  DigitSpanModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/7/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class DigitSpanModel: TestModelProtocol {
    static let shared = DigitSpanModel()
    
    var forwards = [[Int: String]]()
    var backwards = [[Int: String]]()
    
    private init() {}
    
    func getModel() -> [String: Any] {
        var rv = [String: Any]()
        
        for file in forwards {
            for (key, value) in file {
                rv["DSFWD_\(key)_file"] = value
            }
        }
        
        for file in backwards {
            for (key, value) in file {
                rv["DSBWD_\(key)_file"] = value
            }
        }
        
        return rv
    }
    
    func reset() {
        forwards = [[Int: String]]()
        backwards = [[Int: String]]()
    }
}
