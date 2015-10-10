//
//  ServiceEntry+CoreDataProperties.swift
//  Field QA2
//
//  Created by John Jusayan on 10/10/15.
//  Copyright © 2015 University of Nevada, Reno. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import UIKit
import CoreData

extension ServiceEntry {

    @NSManaged var creationDate: NSDate?
    @NSManaged var date: NSDate?
    @NSManaged var modificationDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var operation: String?
    @NSManaged var photo: UIImage?
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var component: Component?
    @NSManaged var creator: Person?
    @NSManaged var documents: NSSet?
    @NSManaged var project: Project?
    @NSManaged var system: System?

}
