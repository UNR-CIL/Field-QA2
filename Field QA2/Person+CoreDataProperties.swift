//
//  Person+CoreDataProperties.swift
//  Field QA2
//
//  Created by John Jusayan on 10/12/15.
//  Copyright © 2015 University of Nevada, Reno. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import UIKit
import CoreData

extension Person {

    @NSManaged var creationDate: NSDate?
    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var modificationDate: NSDate?
    @NSManaged var organization: String?
    @NSManaged var phone: String?
    @NSManaged var photo: UIImage?
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var managedSystems: NSSet?
    @NSManaged var projects: NSSet?
    @NSManaged var serviceEntries: NSSet?

}
