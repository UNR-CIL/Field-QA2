//
//  Component.swift
//  Field QA2
//
//  Created by John Jusayan on 8/13/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class Component: NSManagedObject {

    @NSManaged var accuracy: String
    @NSManaged var attachmentData: NSData
    @NSManaged var installationDate: NSDate
    @NSManaged var lastCalibrationDate: NSDate
    @NSManaged var manufacturer: String
    @NSManaged var model: String
    @NSManaged var name: String
    @NSManaged var operatingRanage: String
    @NSManaged var photo: AnyObject
    @NSManaged var serialNumber: String
    @NSManaged var typeName: String
    @NSManaged var associatedLogicalDevice: NSManagedObject
    @NSManaged var logicalDevice: NSManagedObject

}
