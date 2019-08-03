//
//  CancellationModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/22/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class CancellationModel {
    static let shared = CancellationModel()
    
    var blocks = [String: [Response]]()
    private var hits: Int = 0
    private var omissions: Int = 0
    private var commissions: Int = 0
    private var backwards: Int = 0
    private var totalHits: Int = 0
    private var totalOmissions: Int = 0
    private var totalCommissions: Int = 0
    private var totalBackwards: Int = 0
    
    private init() {}
    
    func printModel() -> [String: Any] {
        var rv = [String: Any]()
        
        reset(all: true)
        
        for (blockName, block) in blocks {
            reset(all: false)
            calculateScores(block: block)
            rv["Cancellation_" + blockName + "_hits"] = hits
            rv["Cancellation_" + blockName + "_omissions"] = omissions
            rv["Cancellation_" + blockName + "_commissions"] = commissions
            rv["Cancellation_" + blockName + "_backward"] = backwards
        }
        
        rv["totalHits"] = totalHits
        rv["totalOmissions"] = totalOmissions
        rv["totalCommissions"] = totalCommissions
        rv["totalBackwards"] = totalBackwards
        
        return rv
    }
    
    private func calculateScores(block: [Response]) {
        var previousIndex = -1
        
        for response in block {
            if response.value == "5" || response.value == "9" {
                hits += 1
                totalHits += 1
            } else {
                commissions += 1
                totalCommissions += 1
            }
            
            if response.index < previousIndex {
                backwards += 1
                totalBackwards += 1
            }
            
            previousIndex = response.index
        }
        
        omissions = 12 - hits
        totalOmissions += omissions
    }
    
    private func reset(all: Bool) {
        if all {
            totalHits = 0
            totalOmissions = 0
            totalCommissions = 0
            totalBackwards = 0
        }
        
        hits = 0
        omissions = 0
        commissions = 0
        backwards = 0
    }
}
