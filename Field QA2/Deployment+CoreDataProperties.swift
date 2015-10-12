//
//  Deployment+CoreDataProperties.swift
//  Field QA2
//
//  Created by John Jusayan on 10/10/15.
//  Copyright © 2015 University of Nevada, Reno. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Deployment {

    @NSManaged var uniqueIdentifier: String?
    @NSManaged var name: String?
    @NSManaged var purpose: String?
    @NSManaged var centerOffset: NSNumber?
    @NSManaged var location: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var heightFromGround: NSNumber?
    @NSManaged var parentLogger: String?
    @NSManaged var establishedDate: NSDate?
    @NSManaged var abandonedDate: NSDate?
    @NSManaged var creationDate: NSDate?
    @NSManaged var modificationDate: NSDate?
    @NSManaged var documents: NSSet?
    @NSManaged var components: NSSet?
    @NSManaged var system: System?

}
