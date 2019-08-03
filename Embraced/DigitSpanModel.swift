//
//  DigitSpanModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/7/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class DigitSpanModel {
    static let shared = DigitSpanModel()
    
    var DSFWD_1_file: String?
    var DSFWD_2_file: String?
    var DSFWD_3_file: String?
    var DSFWD_4_file: String?
    var DSFWD_5_file: String?
    var DSFWD_6_file: String?
    var DSFWD_7_file: String?
    var DSFWD_8_file: String?
    var DSFWD_9_file: String?
    var DSFWD_10_file: String?
    var DSFWD_11_file: String?
    var DSFWD_12_file: String?
    var DSFWD_13_file: String?
    var DSFWD_14_file: String?
    var DSBWD_1_file: String?
    var DSBWD_2_file: String?
    var DSBWD_3_file: String?
    var DSBWD_4_file: String?
    var DSBWD_5_file: String?
    var DSBWD_6_file: String?
    var DSBWD_7_file: String?
    var DSBWD_8_file: String?
    var DSBWD_9_file: String?
    var DSBWD_10_file: String?
    var DSBWD_11_file: String?
    var DSBWD_12_file: String?
    var DSBWD_13_file: String?
    var DSBWD_14_file: String?
    
    private init() {}
    
    func printModel() -> [String: Any] {
        var rv = [String: Any]()
        
        rv["DSFWD_1_file"] = DSFWD_1_file
        rv["DSFWD_2_file"] = DSFWD_2_file
        rv["DSFWD_3_file"] = DSFWD_3_file
        rv["DSFWD_4_file"] = DSFWD_4_file
        rv["DSFWD_5_file"] = DSFWD_5_file
        rv["DSFWD_6_file"] = DSFWD_6_file
        rv["DSFWD_7_file"] = DSFWD_7_file
        rv["DSFWD_8_file"] = DSFWD_8_file
        rv["DSFWD_9_file"] = DSFWD_9_file
        rv["DSFWD_10_file"] = DSFWD_10_file
        rv["DSFWD_11_file"] = DSFWD_11_file
        rv["DSFWD_12_file"] = DSFWD_12_file
        rv["DSFWD_13_file"] = DSFWD_13_file
        rv["DSFWD_14_file"] = DSFWD_14_file
        rv["DSBWD_1_file"] = DSBWD_1_file
        rv["DSBWD_2_file"] = DSBWD_2_file
        rv["DSBWD_3_file"] = DSBWD_3_file
        rv["DSBWD_4_file"] = DSBWD_4_file
        rv["DSBWD_5_file"] = DSBWD_5_file
        rv["DSBWD_6_file"] = DSBWD_6_file
        rv["DSBWD_7_file"] = DSBWD_7_file
        rv["DSBWD_8_file"] = DSBWD_8_file
        rv["DSBWD_9_file"] = DSBWD_9_file
        rv["DSBWD_10_file"] = DSBWD_10_file
        rv["DSBWD_11_file"] = DSBWD_11_file
        rv["DSBWD_12_file"] = DSBWD_12_file
        rv["DSBWD_13_file"] = DSBWD_13_file
        rv["DSBWD_14_file"] = DSBWD_14_file
        
        return rv
    }
}
