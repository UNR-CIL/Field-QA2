//
//  LogicalDevice.swift
//  Field QA2
//
//  Created by John Jusayan on 11/20/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class LogicalDevice: NSManagedObject {

    @NSManaged var deviceId: String?
    @NSManaged var name: String?
    @NSManaged var component: Component?

    @NSManaged var creationDate: NSDate?
    @NSManaged var modificationDate: NSDate?
}
