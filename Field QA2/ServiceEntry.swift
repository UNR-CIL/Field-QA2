//
//  ServiceEntry.swift
//  Field QA2
//
//  Created by John Jusayan on 10/21/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ServiceEntry: NSManagedObject {

    @NSManaged var date: NSDate?
    @NSManaged var notes: String?
    @NSManaged var operation: String?
    @NSManaged var photo: UIImage?
    @NSManaged var name: String?
    @NSManaged var creationDate: NSDate?
    @NSManaged var creator: Person?
    @NSManaged var documents: NSSet

}
