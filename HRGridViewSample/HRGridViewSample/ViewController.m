//
//  ViewController.m
//  HRGridViewSample
//
//  Created by Harry Richardson on 20/10/2014.
//  Copyright (c) 2014 Harry Richardson. All rights reserved.
//

#import "ViewController.h"
#import "HRGridView.h"

@interface ViewController ()

@property (nonatomic, strong) HRGridView *gridView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gridView = [[HRGridView alloc] initWithFrame:self.view.bounds];
    self.gridView.columns = @[@"*", @100, @75];
    self.gridView.rows = @[@"*", @100, @200];
    
    UIView *viewTopLeft = [UIView new];
    viewTopLeft.column = 0;
    viewTopLeft.row = 0;
    viewTopLeft.backgroundColor = [UIColor blueColor];
    [self.gridView addSubview:viewTopLeft];
    
    UIView *viewTop = [UIView new];
    viewTop.column = 1;
    viewTop.row = 0;
    viewTop.backgroundColor = [UIColor greenColor];
    [self.gridView addSubview:viewTop];
    
    UIView *viewTopRight = [UIView new];
    viewTopRight.column = 2;
    viewTopRight.row = 0;
    viewTopRight.rowSpan = 2;
    viewTopRight.backgroundColor = [UIColor purpleColor];
    [self.gridView addSubview:viewTopRight];
    
    UIView *viewLeft = [UIView new];
    viewLeft.column = 0;
    viewLeft.row = 1;
    viewLeft.backgroundColor = [UIColor orangeColor];
    [self.gridView addSubview:viewLeft];
    
    UIView *viewMiddle = [UIView new];
    viewMiddle.column = 1;
    viewMiddle.row = 1;
    viewMiddle.backgroundColor = [UIColor redColor];
    [self.gridView addSubview:viewMiddle];
    
    UIView *viewBottomLeft = [UIView new];
    viewBottomLeft.column = 0;
    viewBottomLeft.row = 2;
    viewBottomLeft.columnSpan = 3;
    viewBottomLeft.backgroundColor = [UIColor yellowColor];
    [self.gridView addSubview:viewBottomLeft];
    
    [self.view addSubview:self.gridView];
    
}

@end
