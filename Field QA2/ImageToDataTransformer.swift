//
//  ImageToDataTransformer.swift
//  Field QA2
//
//  Created by John Jusayan on 8/13/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import Foundation
import UIKit

class ImageToDataTransformer : NSValueTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true;
    }
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    

    override func transformedValue(value: AnyObject!) -> AnyObject? {
        var data : NSData = UIImagePNGRepresentation(value as? UIImage)
        return data
    }
    
    override func reverseTransformedValue(value: AnyObject!) -> AnyObject? {
        return UIImage(data: value as! NSData)
    }
}