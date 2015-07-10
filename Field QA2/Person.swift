//
//  Person.swift
//  Field QA2
//
//  Created by John Jusayan on 11/20/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Person: NSManagedObject {
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var phone: String?
    @NSManaged var organization: String?
    @NSManaged var managedSystems: NSSet
    @NSManaged var projects: NSSet
    @NSManaged var serviceEntries: NSSet
    @NSManaged var photo: UIImage?
    
    @NSManaged var creationDate: NSDate?
    @NSManaged var modificationDate: NSDate?

    var newlyCreated: Bool = false
    
    override func awakeFromInsert() {
        if uniqueIdentifier == nil {
            uniqueIdentifier = NSUUID().UUIDString
        }
        creationDate = NSDate()
        modificationDate = NSDate()
    }
    
    func personWithIdentifier(identifier: String, inManagedObjectContext context: NSManagedObjectContext) -> Person? {
        let fetchRequest = NSFetchRequest(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "uniqueIdentifier == %@", identifier)
        var error: NSError?
        let results: [AnyObject]?
        do {
            results = try context.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            results = nil
        }
        
        if results?.count == 0 {
            return nil
        }
        if let person = results?.first as? Person {
            return person
        }
        else {
            return nil
        }
    }
}
