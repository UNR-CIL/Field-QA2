//
//  ServiceEntry.swift
//  Field QA2
//
//  Created by John Jusayan on 11/20/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ServiceEntry: NSManagedObject {
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var date: NSDate?
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var operation: String?
    @NSManaged var photo: UIImage?
    @NSManaged var creator: Person?
    @NSManaged var documents: NSSet
    @NSManaged var project: Project?
    @NSManaged var system: System?
    @NSManaged var component: Component?
    
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
