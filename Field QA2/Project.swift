//
//  Project.swift
//  Field QA2
//
//  Created by John Jusayan on 10/21/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class Project: NSManagedObject {

    @NSManaged var startedDate: NSDate?
    @NSManaged var originalFundingAgencyName: String?
    @NSManaged var grantNumberString: String?
    @NSManaged var name: String?
    @NSManaged var institutionName: String?
    @NSManaged var principalInvestigator: Person?
    @NSManaged var documents: Document?

}
