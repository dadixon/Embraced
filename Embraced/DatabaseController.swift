//
//  DatabaseController.swift
//  Embraced
//
//  Created by Domonique Dixon on 4/1/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation
import CoreData

class DatabaseController {
    private init() {}
    
    // MARK: - Core Data stack
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Embraced")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    class func saveContext () throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
}
