//
//  ServiceEntry.swift
//  Field QA2
//
//  Created by John Jusayan on 8/13/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class ServiceEntry: NSManagedObject {

    @NSManaged var attachmentData: NSData
    @NSManaged var date: NSDate
    @NSManaged var notes: String
    @NSManaged var operation: String
    @NSManaged var photo: AnyObject
    @NSManaged var creator: Person

}
