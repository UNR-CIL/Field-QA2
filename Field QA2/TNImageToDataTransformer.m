//
//  TNImageToDataTransformer.m
//  TNKit
//
//  Created by John Jusayan on 4/14/14.
//  Copyright (c) 2014 Treeness, LLC. All rights reserved.
//

#import "TNImageToDataTransformer.h"
@import UIKit;

@implementation TNImageToDataTransformer

+ (BOOL)allowsReverseTransformation
{
	return YES;
}

+ (Class)transformedValueClass
{
	return [NSData class];
}


- (id)transformedValue:(id)value
{
    NSData *data = UIImagePNGRepresentation(value);
	return data;
}


- (id)reverseTransformedValue:(id)value
{
	return [[UIImage alloc] initWithData:value];
}

@end
