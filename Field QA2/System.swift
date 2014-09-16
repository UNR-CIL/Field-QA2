//
//  System.swift
//  Field QA2
//
//  Created by John Jusayan on 8/13/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class System: NSManagedObject {

    @NSManaged var details: String?
    @NSManaged var installationDate: NSDate?
    @NSManaged var installationLocation: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var photo: AnyObject?
    @NSManaged var power: String?
    @NSManaged var logicalDevices: NSSet
    @NSManaged var manager: Person

}
