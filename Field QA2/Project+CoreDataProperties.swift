//
//  Project+CoreDataProperties.swift
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

extension Project {

    @NSManaged var creationDate: NSDate?
    @NSManaged var grantNumberString: String?
    @NSManaged var institutionName: String?
    @NSManaged var modificationDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var originalFundingAgencyName: String?
    @NSManaged var startedDate: NSDate?
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var documents: NSSet?
    @NSManaged var principalInvestigator: Person?
    @NSManaged var serviceEntries: NSSet?
    @NSManaged var sites: NSSet?

}
