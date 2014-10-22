//
//  LogicalDevice.swift
//  Field QA2
//
//  Created by John Jusayan on 10/21/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class LogicalDevice: NSManagedObject {

    @NSManaged var deviceId: String?
    @NSManaged var name: String?
    @NSManaged var component: Component?

}
