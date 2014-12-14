//
//  System.swift
//  Field QA2
//
//  Created by John Jusayan on 11/20/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class System: NSManagedObject {
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var details: String?
    @NSManaged var installationDate: NSDate?
    @NSManaged var installationLocation: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var photo: UIImage?
    @NSManaged var power: String?
    @NSManaged var project: Project?
    @NSManaged var components: NSSet
    @NSManaged var manager: Person?
    @NSManaged var serviceEntries: NSSet

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
