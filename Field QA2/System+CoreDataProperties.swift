//
//  System+CoreDataProperties.swift
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

extension System {

    @NSManaged var creationDate: NSDate?
    @NSManaged var details: String?
    @NSManaged var installationDate: NSDate?
    @NSManaged var installationLocation: String?
    @NSManaged var modificationDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var photo: UIImage?
    @NSManaged var power: String?
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var deployments: NSSet?
    @NSManaged var manager: Person?
    @NSManaged var serviceEntries: NSSet?
    @NSManaged var site: Site?

}
