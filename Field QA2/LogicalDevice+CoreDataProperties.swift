//
//  LogicalDevice+CoreDataProperties.swift
//  Field QA2
//
//  Created by John Jusayan on 11/11/15.
//  Copyright © 2015 University of Nevada, Reno. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LogicalDevice {

    @NSManaged var creationDate: NSDate?
    @NSManaged var deviceId: String?
    @NSManaged var modificationDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var component: Component?

}
