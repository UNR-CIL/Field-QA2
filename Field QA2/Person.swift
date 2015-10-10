//
//  Person.swift
//  Field QA2
//
//  Created by John Jusayan on 10/10/15.
//  Copyright © 2015 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    var newlyCreated: Bool = false
    
    override func awakeFromInsert() {
        if uniqueIdentifier == nil {
            uniqueIdentifier = NSUUID().UUIDString
        }
        creationDate = NSDate()
        modificationDate = NSDate()
    }
    
}
