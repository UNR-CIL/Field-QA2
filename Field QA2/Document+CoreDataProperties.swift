//
//  Document+CoreDataProperties.swift
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

extension Document {

    @NSManaged var creationDate: NSDate?
    @NSManaged var modificationDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var path: String?
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var component: Component?
    @NSManaged var deployment: Deployment?
    @NSManaged var project: Project?
    @NSManaged var serviceEntry: ServiceEntry?
    @NSManaged var site: Site?

}
