//
//  NamingTaskModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/29/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class NamingTaskModel: TestModelProtocol {
    static let shared = NamingTaskModel()
    
    var files = [[Int: String]]()
    
    private init() {}
    
    func getModel() -> [String: Any] {
        var rv = [String: Any]()
        
        for file in files {
            for (key, value) in file {
                rv["NAMING_\(key)_file"] = value
            }
        }
        
        return rv
    }
    
    func reset() {
        files = [[Int: String]]()
    }
}
