//
//  CPTResponse.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/19/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

struct CPTResponse: Comparable {
    static func < (lhs: CPTResponse, rhs: CPTResponse) -> Bool {
        if let lTime = lhs.time, let rTime = rhs.time {
            return lTime < rTime
        }
        return false
    }
    
    var index: Int
    var value: Character?
    var prevValue: Character?
    var time: Int?
}
