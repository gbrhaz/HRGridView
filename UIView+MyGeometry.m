//
//  UIView+MyGeometry.m
//  TestGridAware
//
//  Created by Harry Richardson on 30/08/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import "UIView+MyGeometry.h"
#import <objc/runtime.h>

@implementation UIView (MyGeometry)

-(void)setMargin:(UIEdgeInsets)margin
{
    objc_setAssociatedObject(self, @selector(margin), [NSValue valueWithUIEdgeInsets:margin], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)margin
{
    UIEdgeInsets returnValue = UIEdgeInsetsMake(0, 0, 0, 0);
    NSValue *val = objc_getAssociatedObject(self, @selector(margin));
    if (val) {
        [val getValue:&returnValue];
    }
    
    return returnValue;
}

- (void)setRow:(NSInteger)row
{
    objc_setAssociatedObject(self, @selector(row), @(row), OBJC_ASSOCIATION_ASSIGN);
}

-(NSInteger)row
{
    NSNumber *val = objc_getAssociatedObject(self, @selector(row));
    return [val integerValue];
}

-(void)setColumn:(NSInteger)column
{
    objc_setAssociatedObject(self, @selector(column), @(column), OBJC_ASSOCIATION_ASSIGN);
}

-(NSInteger)column
{
    NSNumber *val = objc_getAssociatedObject(self, @selector(column));
    return [val integerValue];
}

-(void)setRowSpan:(NSInteger)rowSpan
{
    objc_setAssociatedObject(self, @selector(rowSpan), @(rowSpan), OBJC_ASSOCIATION_ASSIGN);
}

-(NSInteger)rowSpan
{
    NSNumber *val = objc_getAssociatedObject(self, @selector(rowSpan));
    return [val integerValue];
}

-(void)setColumnSpan:(NSInteger)columnSpan
{
    objc_setAssociatedObject(self, @selector(columnSpan), @(columnSpan), OBJC_ASSOCIATION_ASSIGN);
}

-(NSInteger)columnSpan
{
    NSNumber *val = objc_getAssociatedObject(self, @selector(columnSpan));
    return [val integerValue];
}

@end
