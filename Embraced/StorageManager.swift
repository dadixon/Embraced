//
//  StorageManager.swift
//  Embraced
//
//  Created by Domonique Dixon on 4/30/18.
//  Copyright © 2018 Domonique Dixon. All rights reserved.
//

import Foundation
import CoreData

enum StorageManagerError: Error {
    case failure(message: String)
}

class StorageManager {
    static let sharedInstance = StorageManager()
    
    let context = DatabaseController.persistentContainer.viewContext
    
    private init() {}
    
    public func pushStoredFiles() {
        print(getStoredFiles())
    }
    
    private func getStoredFiles() -> [StoredFile] {
        var rv = [StoredFile]()
        
        let request: NSFetchRequest<StoredFile> = StoredFile.fetchRequest()
        
        do {
            rv = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        return rv
    }
}
