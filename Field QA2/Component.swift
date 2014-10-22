//
//  Component.swift
//  Field QA2
//
//  Created by John Jusayan on 10/21/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Component: NSManagedObject {

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
    @NSManaged var name: String?
    @NSManaged var model: String?
    @NSManaged var serialNumber: String?
    @NSManaged var vendor: String?
    @NSManaged var photo: UIImage?
    @NSManaged var lastCalibratedDate: NSDate?
    @NSManaged var minimumOperatingRange: NSNumber?
    @NSManaged var maximumOperatingRange: NSNumber?
    @NSManaged var minimumAccuracyBound: NSNumber?
    @NSManaged var maxiumumAccuracyBound: NSNumber?
    @NSManaged var wiringNotes: String?
    @NSManaged var parentLogger: String?
    @NSManaged var measurementProperty: String?
    @NSManaged var manufacturer: String?
    @NSManaged var supplier: String?
    @NSManaged var system: System?
    @NSManaged var documents: NSSet
    @NSManaged var logicalDevices: NSSet

}
