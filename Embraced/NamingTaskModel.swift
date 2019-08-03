//
//  NamingTaskModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/29/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class NamingTaskModel {
    static let shared = NamingTaskModel()
    
    var file_1: String?
    var file_2: String?
    var file_3: String?
    var file_4: String?
    var file_5: String?
    var file_6: String?
    var file_7: String?
    var file_8: String?
    var file_9: String?
    var file_10: String?
    var file_11: String?
    var file_12: String?
    var file_13: String?
    var file_14: String?
    var file_15: String?
    var file_16: String?
    var file_17: String?
    var file_18: String?
    var file_19: String?
    var file_20: String?
    
    private init() {}
    
    func printModel() -> [String: Any] {
        var rv = [String: Any]()
        
        rv["NAMING1_file"] = file_1
        rv["NAMING2_file"] = file_2
        rv["NAMING3_file"] = file_3
        rv["NAMING4_file"] = file_4
        rv["NAMING5_file"] = file_5
        rv["NAMING6_file"] = file_6
        rv["NAMING7_file"] = file_7
        rv["NAMING8_file"] = file_8
        rv["NAMING9_file"] = file_9
        rv["NAMING10_file"] = file_10
        rv["NAMING11_file"] = file_11
        rv["NAMING12_file"] = file_12
        rv["NAMING13_file"] = file_13
        rv["NAMING14_file"] = file_14
        rv["NAMING15_file"] = file_15
        rv["NAMING16_file"] = file_16
        rv["NAMING17_file"] = file_17
        rv["NAMING18_file"] = file_18
        rv["NAMING19_file"] = file_19
        rv["NAMING20_file"] = file_20
        
        return rv
    }
}
