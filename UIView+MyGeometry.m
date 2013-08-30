//
//  UIView+MyGeometry.m
//  TestGridAware
//
//  Created by Harry Richardson on 30/08/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import "UIView+MyGeometry.h"
#import <objc/runtime.h>

static char marginKey;
static char rowKey;
static char rowSpanKey;
static char columnKey;
static char columnSpanKey;

@implementation UIView (MyGeometry)

-(void)setMargin:(UIEdgeInsets)margin
{
    objc_setAssociatedObject(self, &marginKey, [NSValue valueWithUIEdgeInsets:margin], OBJC_ASSOCIATION_ASSIGN);
}

- (UIEdgeInsets)margin
{
    UIEdgeInsets returnValue = UIEdgeInsetsMake(0, 0, 0, 0);
    NSValue *val = objc_getAssociatedObject(self, &marginKey);
    if (val) {
        [val getValue:&returnValue];
    }
    
    return returnValue;
}

- (void)setRow:(NSInteger)row
{
    objc_setAssociatedObject(self, &rowKey, @(row), OBJC_ASSOCIATION_ASSIGN);
}

-(NSInteger)row
{
    NSNumber *val = objc_getAssociatedObject(self, &rowKey);
    return [val integerValue];
}

-(void)setColumn:(NSInteger)column
{
    objc_setAssociatedObject(self, &columnKey, @(column), OBJC_ASSOCIATION_ASSIGN);
}

-(NSInteger)column
{
    NSNumber *val = objc_getAssociatedObject(self, &columnKey);
    return [val integerValue];
}

-(void)setRowSpan:(NSInteger)rowSpan
{
    objc_setAssociatedObject(self, &rowSpanKey, @(rowSpan), OBJC_ASSOCIATION_ASSIGN);
}

-(NSInteger)rowSpan
{
    NSNumber *val = objc_getAssociatedObject(self, &rowSpanKey);
    return [val integerValue];
}

-(void)setColumnSpan:(NSInteger)columnSpan
{
    objc_setAssociatedObject(self, &columnSpanKey, @(columnSpan), OBJC_ASSOCIATION_ASSIGN);
}

-(NSInteger)columnSpan
{
    NSNumber *val = objc_getAssociatedObject(self, &columnSpanKey);
    return [val integerValue];
}

@end
