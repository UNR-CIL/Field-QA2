//
//  Person.swift
//  Field QA2
//
//  Created by John Jusayan on 11/20/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Person: NSManagedObject {
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var phone: String?
    @NSManaged var managedSystems: NSSet
    @NSManaged var projects: NSSet
    @NSManaged var serviceEntries: NSSet
    @NSManaged var photo: UIImage?
    
    @NSManaged var creationDate: NSDate?
    @NSManaged var modificationDate: NSDate?
    
    override func awakeFromInsert() {
        if uniqueIdentifier == nil {
            uniqueIdentifier = NSUUID().UUIDString
        }
        creationDate = NSDate()
        modificationDate = NSDate()
    }
}
