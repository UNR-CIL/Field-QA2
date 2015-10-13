//
//  Deployment+CoreDataProperties.swift
//  Field QA2
//
//  Created by John Jusayan on 10/12/15.
//  Copyright © 2015 University of Nevada, Reno. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Deployment {

    @NSManaged var abandonedDate: NSDate?
    @NSManaged var centerOffset: NSNumber?
    @NSManaged var creationDate: NSDate?
    @NSManaged var establishedDate: NSDate?
    @NSManaged var heightFromGround: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var location: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var modificationDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var parentLogger: String?
    @NSManaged var purpose: String?
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var components: NSSet?
    @NSManaged var documents: NSSet?
    @NSManaged var system: System?

}
