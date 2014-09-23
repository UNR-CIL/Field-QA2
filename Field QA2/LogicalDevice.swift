//
//  LogicalDevice.swift
//  Field QA2
//
//  Created by John Jusayan on 8/13/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class LogicalDevice: NSManagedObject {

    @NSManaged var centerOffset: NSNumber?
    @NSManaged var dataInterval: String?
    @NSManaged var dataStreamDetails: String?
    @NSManaged var heightFromGround: NSNumber?
    @NSManaged var installationDate: NSDate?
    @NSManaged var installationDetails: String?
    @NSManaged var installationLocation: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var purpose: String?
    @NSManaged var typeName: String?
    @NSManaged var unitDescription: String?
    @NSManaged var components: NSSet
    @NSManaged var installedComponent: Component?
    @NSManaged var system: System?

}
