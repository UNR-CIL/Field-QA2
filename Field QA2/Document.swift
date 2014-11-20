//
//  Document.swift
//  Field QA2
//
//  Created by John Jusayan on 11/20/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class Document: NSManagedObject {

    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var path: String?
    @NSManaged var component: Component?
    @NSManaged var project: Project?
    @NSManaged var serviceEntry: ServiceEntry?

}
