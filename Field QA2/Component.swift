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

    @NSManaged var accuracy: String?
    @NSManaged var attachmentData: NSData?
    @NSManaged var installationDate: NSDate?
    @NSManaged var lastCalibrationDate: NSDate?
    @NSManaged var manufacturer: String?
    @NSManaged var model: String?
    @NSManaged var name: String?
    @NSManaged var details: String?
    @NSManaged var operatingRange: String?
    @NSManaged var photo: AnyObject?
    @NSManaged var serialNumber: String?
    @NSManaged var typeName: String?
    // associatedLogicalDevice and logicalDevice should both point to the same object
    // The reason that there's two references is because Core Data insists on one-to-one inverses
    @NSManaged var associatedLogicalDevice: NSManagedObject
    @NSManaged var logicalDevice: NSManagedObject

}
