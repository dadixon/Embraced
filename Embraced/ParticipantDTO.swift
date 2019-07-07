//
//  ParticipantDTO.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/24/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class ParticipantDTO {
    static let shared = ParticipantDTO()
    
    var data: [Participant] = []
    
    private init() {}
    
    
}
