//
//  Participant.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/24/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class Participant {
    let id: String
    let data: [String: Any]
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.data = data
    }
    
}
