//
//  Person.swift
//  Field QA2
//
//  Created by John Jusayan on 10/10/15.
//  Copyright © 2015 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
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
        let results: [AnyObject]?
        do {
            results = try context.executeFetchRequest(fetchRequest)
        } catch _ as NSError {
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
