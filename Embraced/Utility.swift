//
//  Utility.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/9/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class Utility {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
