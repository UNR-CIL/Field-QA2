//
//  Project.swift
//  Field QA2
//
//  Created by John Jusayan on 11/20/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class Project: NSManagedObject {

    @NSManaged var grantNumberString: String?
    @NSManaged var institutionName: String?
    @NSManaged var name: String?
    @NSManaged var originalFundingAgencyName: String?
    @NSManaged var startedDate: NSDate?
    @NSManaged var systems: NSSet
    @NSManaged var documents: Document?
    @NSManaged var principalInvestigator: Person?
    @NSManaged var serviceEntries: NSSet
    
    @NSManaged var creationDate: NSDate?
    @NSManaged var modificationDate: NSDate?
}
