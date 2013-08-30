//
//  UIView+MyGeometry.h
//  TestGridAware
//
//  Created by Harry Richardson on 30/08/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>

// Went with a category and objc_associatedObject as the alternative was to 
@interface UIView (MyGeometry)

// The margin provides an inset from the cell boundary
@property (nonatomic) UIEdgeInsets margin;

// Specify the row in the grid for this view to go into
@property (nonatomic) NSInteger row;

// Specify the number of rows this view spans
@property (nonatomic) NSInteger rowSpan;

// Specify the column in the grid for this view to go into
@property (nonatomic) NSInteger column;

// Specify the number of columns this view spans
@property (nonatomic) NSInteger columnSpan;

@end
