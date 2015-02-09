//
//  Project.swift
//  Field QA2
//
//  Created by John Jusayan on 11/20/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import CoreData

class Project: NSManagedObject {
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var grantNumberString: String?
    @NSManaged var institutionName: String?
    @NSManaged var name: String?
    @NSManaged var originalFundingAgencyName: String?
    @NSManaged var startedDate: NSDate?
    
    @NSManaged var systems: NSSet
    @NSManaged var documents: NSSet
    @NSManaged var principalInvestigator: Person?
    @NSManaged var serviceEntries: NSSet
    
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
    
    private lazy var dictionaryValue: NSMutableDictionary? = {
        var dictionary = NSMutableDictionary()
        
        for entityProperty in self.entity.propertiesByName {
            let propertyName: NSString = entityProperty.1.name
            
            switch  propertyName {
            case "startedDate":
                if let date = self.valueForKey(propertyName as! String) as? NSDate {
                    dictionary[propertyName] = date.timeIntervalSince1970
                }
            case "creationDate":
                if let date = self.valueForKey(propertyName as! String) as? NSDate {
                    dictionary[propertyName] = date.timeIntervalSince1970
                }
            case "modificationDate":
                if let date = self.valueForKey(propertyName as! String) as? NSDate {
                    dictionary[propertyName] = date.timeIntervalSince1970
                }
            case "principalInvestigator":
                if let person = self.valueForKey(propertyName as! String) as? Person {
                    dictionary[propertyName] = [person.uniqueIdentifier!]
                }
            case "systems":
                fallthrough
            case "documents":
                fallthrough
            case "serviceEntries":
                if let set = self.valueForKey(propertyName as! String) as? NSSet {
                    var itemIds = [AnyObject]()
                    for item in set {
                        itemIds.append(item.valueForKey("uniqueIdentifier")!)
                    }
                    dictionary[propertyName] = itemIds
                }
            default:
                if let value: AnyObject = self.valueForKey(propertyName as! String) {
                    dictionary[propertyName] = value
                }
            }
        }
        return dictionary
    }()
    
    private func json() -> NSData? {
        return NSJSONSerialization.dataWithJSONObject(self.dictionaryValue!, options: NSJSONWritingOptions.allZeros, error: nil)
    }
}
