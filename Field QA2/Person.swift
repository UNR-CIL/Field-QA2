//
//  Person.swift
//  Field QA2
//
//  Created by John Jusayan on 10/21/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

    @NSManaged var email: String?
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var managedSystems: NSSet
    @NSManaged var serviceEntries: NSSet
    @NSManaged var projects: NSSet

}
