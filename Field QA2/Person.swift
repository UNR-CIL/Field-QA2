//
//  Person.swift
//  Field QA2
//
//  Created by John Jusayan on 8/13/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

    @NSManaged var email: String
    @NSManaged var name: String
    @NSManaged var phone: String
    @NSManaged var managedSystem: NSManagedObject
    @NSManaged var serviceEntry: NSManagedObject

}
