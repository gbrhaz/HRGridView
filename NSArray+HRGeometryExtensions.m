//
//  NSArray+HRGeometryExtensions.m
//  TestGridAware
//
//  Created by Harry Richardson on 30/08/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import "NSArray+HRGeometryExtensions.h"

@implementation NSArray (HRGeometryExtensions)

-(double)sum
{
    double value = 0;
    for (NSNumber *number in self) {
        value += [number doubleValue];
    }
    return value;
}

@end
