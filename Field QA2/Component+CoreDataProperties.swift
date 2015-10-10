//
//  Component+CoreDataProperties.swift
//  Field QA2
//
//  Created by John Jusayan on 10/10/15.
//  Copyright © 2015 University of Nevada, Reno. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import UIKit
import CoreData

extension Component {

    @NSManaged var calibrationStatus: NSNumber?
    @NSManaged var creationDate: NSDate?
    @NSManaged var dataInterval: String?
    @NSManaged var dataStreamDetails: String?
    @NSManaged var installationDetails: String?
    @NSManaged var installationLocation: String?
    @NSManaged var lastCalibratedDate: NSDate?
    @NSManaged var manufacturer: String?
    @NSManaged var maximumAccuracyBound: NSNumber?
    @NSManaged var maximumOperatingRange: NSNumber?
    @NSManaged var measurementProperty: String?
    @NSManaged var minimumAccuracyBound: NSNumber?
    @NSManaged var minimumOperatingRange: NSNumber?
    @NSManaged var model: String?
    @NSManaged var modificationDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var photo: UIImage?
    @NSManaged var serialNumber: String?
    @NSManaged var supplier: String?
    @NSManaged var typeName: String?
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var unitDescription: String?
    @NSManaged var vendor: String?
    @NSManaged var wiringNotes: String?
    @NSManaged var documents: NSSet?
    @NSManaged var logicalDevices: NSSet?
    @NSManaged var serviceEntries: NSSet?
    @NSManaged var deployment: Deployment?

}
