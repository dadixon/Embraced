//
//  UserInputs+CoreDataProperties.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/17/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserInputs {

    @NSManaged var day: String?
    @NSManaged var country: String?
    @NSManaged var county: String?
    @NSManaged var city: String?
    @NSManaged var location: String?
    @NSManaged var floor: String?

}
