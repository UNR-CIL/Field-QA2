//
//  Site+CoreDataProperties.swift
//  Field QA2
//
//  Created by John Jusayan on 11/11/15.
//  Copyright © 2015 University of Nevada, Reno. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import UIKit
import CoreData

extension Site {

    @NSManaged var alias: String?
    @NSManaged var creationDate: NSDate?
    @NSManaged var gpsLandmark: String?
    @NSManaged var landmarkPhoto: UIImage?
    @NSManaged var landOwner: String?
    @NSManaged var location: String?
    @NSManaged var modificationDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var permitHolder: String?
    @NSManaged var timeZoneAbbreviation: String?
    @NSManaged var timeZoneName: String?
    @NSManaged var timeZoneOffset: String?
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var projectIdentifier: String?
    @NSManaged var documents: NSSet?
    @NSManaged var project: Project?
    @NSManaged var systems: NSSet?

}
