//
//  HRGridView.m
//  TestGridAware
//
//  Created by Harry Richardson on 30/08/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import "HRGridView.h"
#import "UIView+MyGeometry.h"
#import "NSArray+HRGeometryExtensions.h"

@interface HRGridView()

@property (nonatomic, copy) NSMutableArray *columnsExact;
@property (nonatomic, copy) NSMutableArray *rowsExact;

@end

@implementation HRGridView

- (void)calculateColumnsAndRows
{
    _columnsExact = [NSMutableArray array];
    _rowsExact = [NSMutableArray array];
    CGFloat currentWidthRemaining = CGRectGetWidth(self.frame);
    CGFloat currentHeightRemaining = CGRectGetHeight(self.frame);
    
    NSArray *exactColumnValues = [self exactFiguresForRowOrColumn:self.columns];
    NSArray *exactRowValues = [self exactFiguresForRowOrColumn:self.rows];
    
    // Exact row/columns
    for (NSNumber *width in exactColumnValues) {
        currentWidthRemaining -= [width floatValue];
        [self.columnsExact addObject:width];
    }
    
    for (NSNumber *height in exactRowValues) {
        currentHeightRemaining -= [height floatValue];
        [self.rowsExact addObject:height];
    }
    
    // * row/columns - they take up the remaining space of the container.
    // The value of a particular row/column is determined by summing up all the star ratios
    // and diving what's left of the space in the container, by the sum of the ratios. This value
    // is then multiplied by each row/column star value to determine how much space it has.
    // For example, * * *, would split the the three row/columns into 3 equal parts
    // * 2* * would give the middle row/column double the space as the other two
    
    NSArray *starColumnValues = [self starValuesForRowOrColumn:self.columns];
    NSArray *starRowValues = [self starValuesForRowOrColumn:self.rows];
    
    // Column ratios
    NSMutableArray *columnRatio = [NSMutableArray array];
    for (NSString *starValue in starColumnValues)
    {
        if (starValue.length == 1) {
            [columnRatio addObject:@1];
        } else {
            NSInteger value = [[starValue substringToIndex:starValue.length-1] integerValue];
            [columnRatio addObject:@(value)];
        }
    }
    double columnRatioSum = [columnRatio sum];
    CGFloat columnBase = currentWidthRemaining / columnRatioSum;
    for (NSNumber *number in columnRatio) {
        double value = [number doubleValue];
        value = value * columnBase;
        [self.columnsExact addObject:@(value)];
    }
    
    // Row ratios
    NSMutableArray *rowRatio = [NSMutableArray array];
    for (NSString *starValue in starRowValues)
    {
        if (starValue.length == 1) {
            [rowRatio addObject:@1];
        } else {
            NSInteger value = [[starValue substringToIndex:starValue.length-1] integerValue];
            [rowRatio addObject:@(value)];
        }
    }
    double rowRatioSum = [rowRatio sum];
    CGFloat rowBase = currentHeightRemaining / rowRatioSum;
    for (NSNumber *number in rowRatio) {
        double value = [number doubleValue];
        value = value * rowBase;
        [self.rowsExact addObject:@(value)];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self calculateColumnsAndRows];
    
    for (UIView *subview in self.subviews) {
        CGPoint cellOrigin = [self originForRow:subview.row column:subview.column];
        CGSize cellSize = [self sizeForRow:subview.row column:subview.column
                                   rowSpan:subview.rowSpan columnSpan:subview.columnSpan];
        UIEdgeInsets margin = subview.margin;
        subview.frame = CGRectMake(cellOrigin.x + margin.left,
                                   cellOrigin.y + margin.top,
                                   cellSize.width - margin.left - margin.right,
                                   cellSize.height - margin.top - margin.bottom);
    }
    
}

#pragma mark - Helpers

- (CGPoint)originForRow:(NSInteger)row column:(NSInteger)column
{
    NSAssert(self.rowsExact.count > row, @"You are trying to place a subview in a row that doesn't exist");
    NSAssert(self.columnsExact.count > column, @"You are trying to place a subview in a column that doesn't exist");
    
    CGFloat originX = 0;
    CGFloat originY = 0;
    
    for (NSInteger i = 0; i < row; i++) {
        originY += [self.rowsExact[i] floatValue];
    }
    for (NSInteger i = 0; i < column; i++) {
        originX += [self.columnsExact[i] floatValue];
    }
    
    return CGPointMake(originX, originY);
}

- (CGSize)sizeForRow:(NSInteger)row
              column:(NSInteger)column
             rowSpan:(NSInteger)rowSpan
          columnSpan:(NSInteger)columnSpan
{
    NSAssert(self.rowsExact.count > row, @"You are trying to place a subview in a row that doesn't exist");
    NSAssert(self.columnsExact.count > column, @"You are trying to place a subview in a column that doesn't exist");
    
    CGFloat sizeX = 0;
    for (NSInteger i = column; i < column + MAX(1, columnSpan); i++) {
        NSAssert(self.columnsExact.count > column + MAX(1, columnSpan), @"The column span you have specified exceeds the number of columns");
        sizeX += [self.columnsExact[i] floatValue];
    }
    
    CGFloat sizeY = 0;
    for (NSInteger i = row; i < row + MAX(1, rowSpan); i++) {
        NSAssert(self.rowsExact.count > row + MAX(1, rowSpan), @"The row span you have specified exceeds the number of rows");
        sizeY += [self.rowsExact[i] floatValue];
    }
    
    return CGSizeMake(sizeX, sizeY);
}

- (NSArray*)exactFiguresForRowOrColumn:(NSArray*)array
{
    NSMutableArray *values = [NSMutableArray array];
    
    for (id value in array) {
        if ([value isKindOfClass:[NSNumber class]]) {
            [values addObject:value];
        }
    }
    return values;
}

- (NSArray*)starValuesForRowOrColumn:(NSArray*)array
{
    NSMutableArray *values = [NSMutableArray array];
    
    for (id value in array) {
        if ([value isKindOfClass:[NSString class]]) {
            if ([value rangeOfString:@"*"].location != NSNotFound) {
                [values addObject:value];
            }
        }
    }
    return values;
}

@end
