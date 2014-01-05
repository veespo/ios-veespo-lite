//
//  VEChartViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 03/01/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import "VEChartViewController.h"

@interface VEChartViewController () {
    UILabel *tagNameLabel;
    JBBarChartView *barChartView;
}

@end

@implementation VEChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromHex(0x313131);
    
    barChartView = [[JBBarChartView alloc] initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width - 20, 250)];
    barChartView.delegate = self;
    barChartView.dataSource = self;
    barChartView.headerPadding = 10;
    barChartView.backgroundColor = UIColorFromHex(0x3c3c3c);
    [self.view addSubview:barChartView];
    
    UIView *headerView = headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, barChartView.frame.size.width, 50.0f)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, headerView.frame.size.width, 35)];
    textLabel.text = NSLocalizedString(@"Venue tags", nil);
    textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:24];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor lightTextColor];
    textLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:textLabel];
    barChartView.headerView = headerView;
    
    [barChartView reloadData];
    
    tagNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 340, [UIScreen mainScreen].bounds.size.width, 30)];
    tagNameLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:24];
    tagNameLabel.textAlignment = NSTextAlignmentCenter;
    tagNameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:tagNameLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [barChartView setState:JBChartViewStateExpanded animated:YES callback:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [barChartView setState:JBChartViewStateCollapsed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JBBarChartViewDelegate

- (NSInteger)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSInteger)index
{
    return [[self.avgRatesArray objectAtIndex:index] integerValue]; // height of bar at index
}

#pragma mark - JBBarChartViewDataSource

- (NSInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return self.avgRatesArray.count; // number of bars in chart
}

- (UIView *)barViewForBarChartView:(JBBarChartView *)barChartView atIndex:(NSInteger)index
{
    UIView *barView = [[UIView alloc] init];
    barView.backgroundColor = (index % 2 == 0) ? UIColorFromHex(0x1D7800) : UIColorFromHex(0x870013);
    return barView;
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSInteger)index
{
    tagNameLabel.text = [NSString stringWithFormat:@"%@: %d", [self.tagNamesArray objectAtIndex:index],[[self.avgRatesArray objectAtIndex:index] integerValue]];
}

@end
