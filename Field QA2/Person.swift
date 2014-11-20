//
//  Person.swift
//  Field QA2
//
//  Created by John Jusayan on 11/20/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

    @NSManaged var email: String?
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var managedSystems: NSSet
    @NSManaged var projects: NSSet
    @NSManaged var serviceEntries: NSSet

}
