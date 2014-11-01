//
//  HRGridView.h
//  TestGridAware
//
//  Created by Harry Richardson on 30/08/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+MyGeometry.h"


@interface HRGridView : UIView

@property (nonatomic, strong) NSArray *columns;
@property (nonatomic, strong) NSArray *rows;

@end

typedef NS_ENUM(NSInteger, HRLinearLayout) {
    HRLinearLayoutVertical,
    HRLinearLayoutHorizontal
};

@interface HRLinearLayoutView : HRGridView

@property (nonatomic, readonly) HRLinearLayout layoutDirection;

- (instancetype)initWithFrame:(CGRect)frame layoutDirection:(HRLinearLayout)direction;


@end

