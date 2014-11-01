//
//  HRGridView.m
//  TestGridAware
//
//  Created by Harry Richardson on 30/08/2013.
//  Copyright (c) 2013 Harry Richardson. All rights reserved.
//

#import "HRGridView.h"
#import "NSArray+HRGeometryExtensions.h"

@interface HRGridView()

@property (nonatomic, copy) NSMutableArray *columnsExact;
@property (nonatomic, copy) NSMutableArray *rowsExact;

@end

@implementation HRGridView

#pragma mark - Setup

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

#pragma mark - Overrides

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

- (void)calculateColumnsAndRows
{
    _columnsExact = [NSMutableArray arrayWithArray:self.columns];
    _rowsExact = [NSMutableArray arrayWithArray:self.rows];
    
    CGFloat currentWidthRemaining = CGRectGetWidth(self.frame);
    CGFloat currentHeightRemaining = CGRectGetHeight(self.frame);
    
    for (id value in [self.columnsExact hr_itemsOfClass:[NSNumber class]]) {
        currentWidthRemaining -= [value floatValue];
    }
    for (id value in [self.rowsExact hr_itemsOfClass:[NSNumber class]]) {
        currentHeightRemaining -= [value floatValue];
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
    NSArray *columnRatio = [self ratiosForStarValues:starColumnValues];
    self.columnsExact = [self convertStarRatios:columnRatio usingExactValues:self.columnsExact withRemainingSpace:currentWidthRemaining];
    
    // Row ratios
    NSArray *rowRatio = [self ratiosForStarValues:starRowValues];
    self.rowsExact = [self convertStarRatios:rowRatio usingExactValues:self.rowsExact withRemainingSpace:currentHeightRemaining];
}


- (NSMutableArray*)convertStarRatios:(NSArray*)ratios usingExactValues:(NSArray*)exactValues withRemainingSpace:(CGFloat)space
{
    double ratioSum = [ratios hr_sum];
    CGFloat columnBase = space / ratioSum;
    NSMutableArray *exactValuesCopy = [NSMutableArray arrayWithArray:exactValues];
    
    NSInteger currentRatio = 0;
    NSInteger currentIndex = 0;
    for (id value in exactValues) {
        if ([self isStarItem:value]) {
            double result = [ratios[currentRatio] doubleValue] * columnBase;
            exactValuesCopy[currentIndex] = @(result);
            
            currentRatio++;
        }
        
        currentIndex++;
    }
    
    return exactValuesCopy;
}

- (BOOL)isStarItem:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        if ([value rangeOfString:@"*"].location != NSNotFound) {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray*)ratiosForStarValues:(NSArray*)starValues
{
    NSMutableArray *ratios = [NSMutableArray array];
    for (NSString *starValue in starValues)
    {
        if (starValue.length == 1) {
            [ratios addObject:@1];
        } else {
            NSInteger value = [self starValueRatio:starValue];
            [ratios addObject:@(value)];
        }
    }
    
    return ratios;
}

- (NSInteger)starValueRatio:(NSString *)starString {
    NSInteger value = [[starString substringToIndex:starString.length-1] integerValue];
    return value;
}

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
        NSAssert(self.columnsExact.count >= column + columnSpan, @"The column span you have specified exceeds the number of columns");
        sizeX += [self.columnsExact[i] floatValue];
    }
    
    CGFloat sizeY = 0;
    for (NSInteger i = row; i < row + MAX(1, rowSpan); i++) {
        NSAssert(self.rowsExact.count >= row + rowSpan, @"The row span you have specified exceeds the number of rows");
        sizeY += [self.rowsExact[i] floatValue];
    }
    
    return CGSizeMake(sizeX, sizeY);
}

- (NSArray*)starValuesForRowOrColumn:(NSArray*)array
{
    NSArray *strings = [array hr_itemsOfClass:[NSString class]];
    NSMutableArray *values = [NSMutableArray array];
    
    for (id value in strings) {
        if ([self isStarItem:value]) {
            [values addObject:value];
        }
    }
    return values;
}

@end

@implementation HRLinearLayoutView

- (instancetype)initWithFrame:(CGRect)frame layoutDirection:(HRLinearLayout)direction {
    if (self = [super initWithFrame:frame]) {
        _layoutDirection = direction;
    }
    return self;
}

- (void)addSubview:(UIView *)view {
    if (self.layoutDirection == HRLinearLayoutHorizontal) {
        NSMutableArray *columns = [self.columns mutableCopy];
        if (!columns) {
            columns = [NSMutableArray array];
        }
        [columns addObject:@"*"];
        self.columns = columns;
        if (!self.rows) {
            self.rows = @[@"*"];
        }
    } else {
        NSMutableArray *rows = [self.columns mutableCopy];
        if (!rows) {
            rows = [NSMutableArray array];
        }
        [rows addObject:@"*"];
        self.rows = rows;
        if (!self.columns) {
            self.columns = @[@"*"];
        }
    }
    [super addSubview:view];
}

- (void)layoutSubviews {
    NSInteger column = 0;
    NSInteger row = 0;
    for (UIView *view in self.subviews) {
        if (self.layoutDirection == HRLinearLayoutHorizontal) {
            view.column = column++;
        } else {
            view.row = row++;
        }
    }
    [super layoutSubviews];
}

@end
