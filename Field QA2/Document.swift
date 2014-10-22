//
//  Document.swift
//  Field QA2
//
//  Created by John Jusayan on 10/21/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class Document: NSManagedObject {

    @NSManaged var path: String?
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var project: Project?
    @NSManaged var component: Component?
    @NSManaged var serviceEntry: ServiceEntry?

}
