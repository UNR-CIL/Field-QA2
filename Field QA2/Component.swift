//
//  Component.swift
//  Field QA2
//
//  Created by John Jusayan on 11/20/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Component: NSManagedObject {
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var centerOffset: NSNumber?
    @NSManaged var dataInterval: String?
    @NSManaged var dataStreamDetails: String?
    @NSManaged var heightFromGround: NSNumber?
    @NSManaged var installationDate: NSDate?
    @NSManaged var installationDetails: String?
    @NSManaged var installationLocation: String?
    @NSManaged var lastCalibratedDate: NSDate?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var manufacturer: String?
    @NSManaged var maximumOperatingRange: NSNumber?
    @NSManaged var maxiumumAccuracyBound: NSNumber?
    @NSManaged var measurementProperty: String?
    @NSManaged var minimumAccuracyBound: NSNumber?
    @NSManaged var minimumOperatingRange: NSNumber?
    @NSManaged var model: String?
    @NSManaged var name: String?
    @NSManaged var parentLogger: String?
    @NSManaged var photo: UIImage?
    @NSManaged var purpose: String?
    @NSManaged var serialNumber: String?
    @NSManaged var supplier: String?
    @NSManaged var typeName: String?
    @NSManaged var unitDescription: String?
    @NSManaged var vendor: String?
    @NSManaged var wiringNotes: String?
    @NSManaged var documents: NSSet
    @NSManaged var logicalDevices: NSSet
    @NSManaged var system: System?
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
