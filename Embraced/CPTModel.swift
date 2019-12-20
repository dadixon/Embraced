//
//  CPTModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/19/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class CPTModel: TestModelProtocol {
    static let shared = CPTModel()
    
    var blocks = [String: [CPTResponse]]()
    private var hits: Int = 0
    private var omissions: Int = 0
    private var commissions: Int = 0
    private var average: Double = 0.0
    private var median: Double = 0.0
    
    private init() {}
    
    func getModel() -> [String : Any] {
        var rv = [String: Any]()
        
        reset(all: true)
        
        for (blockName, blockResponses) in blocks {
            var hitBlocks: [CPTResponse]?
            
            for response in blockResponses {
                if let time = response.time {
                    rv["CPT_\(blockName)_\(response.index)"] = time
                } else {
                    rv["CPT_\(blockName)_\(response.index)"] = ""
                }
                
                if let prevV = response.prevValue {
                    if prevV == "X" && response.value == "A" {
                        hitBlocks?.append(response)
                        hits += 1
                    } else {
                        commissions += 1
                    }
                }
            }
            
            omissions = 20 - hits
            
            rv["CPT_\(blockName)_hits"] = hits
            rv["CPT_\(blockName)_commissions"] = commissions
            rv["CPT_\(blockName)_omissions"] = omissions
            
            if let hitResponses = hitBlocks {
                rv["CPT_\(blockName)_average"] = averageHits(responses: hitResponses)
                rv["CPT_\(blockName)_median"] = medianHits(responses: hitResponses)
            }
        }
        
        return rv
    }
    
    func reset() {
        blocks = [String: [CPTResponse]]()
    }
    
    private func reset(all: Bool) {
        hits = 0
        omissions = 0
        commissions = 0
        average = 0.0
        median = 0.0
    }
    
    private func averageHits(responses: [CPTResponse]) -> Double {
        var total = 0
        
        for response in responses {
            total += response.time!
        }
        
        return Double(total / responses.count)
    }
    
    private func medianHits(responses: [CPTResponse]) -> Double {
        let sorted = responses.sorted()
        if sorted.count % 2 == 0 {
            return Double((sorted[(sorted.count / 2)].time! + sorted[(sorted.count / 2) - 1].time!)) / 2
        } else {
            return Double(sorted[(sorted.count - 1) / 2].time!)
        }
    }
}
