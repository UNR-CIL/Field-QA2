//
//  Document.swift
//  Field QA2
//
//  Created by John Jusayan on 11/20/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class Document: NSManagedObject {
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var path: String?
    @NSManaged var component: Component?
    @NSManaged var project: Project?
    @NSManaged var serviceEntry: ServiceEntry?
    
    @NSManaged var creationDate: NSDate?
    @NSManaged var modificationDate: NSDate?
    
    var newlyCreated: Bool = false
    
    override func awakeFromInsert() {
        if uniqueIdentifier == nil {
            uniqueIdentifier = NSUUID().UUIDString
        }
        creationDate = NSDate()
        modificationDate = NSDate()
    }
}
