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
    self.view.backgroundColor = [UIColor whiteColor];
    
    JBBarChartView *barChartView = [[JBBarChartView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    barChartView.delegate = self;
    barChartView.dataSource = self;
    [self.view addSubview:barChartView];
    UIView *headerView = headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 22.0f)];
    headerView.backgroundColor = UIColorFromRGB(0xDBDBDB);
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
    textLabel.text = NSLocalizedString(@"Venue tags", nil);
    textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:([UIFont systemFontSize] * 0.7f)];
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:textLabel];
    barChartView.headerView = headerView;
    [barChartView reloadData];
    
    tagNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, [UIScreen mainScreen].bounds.size.width, 30)];
    tagNameLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:24];
    tagNameLabel.textAlignment = NSTextAlignmentCenter;
    tagNameLabel.textColor = [UIColor blackColor];
    [self.view addSubview:tagNameLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return self.avgRatesArray.count; // number of bars in chart
}

- (NSInteger)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSInteger)index
{
    return [[self.avgRatesArray objectAtIndex:index] integerValue]; // height of bar at index
}

- (UIView *)barViewForBarChartView:(JBBarChartView *)barChartView atIndex:(NSInteger)index
{
    UIView *barView = [[UIView alloc] init];
    barView.backgroundColor = UIColorFromRGB(0x1D7800);
    return barView;
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSInteger)index
{
    tagNameLabel.text = [NSString stringWithFormat:@"%@: %d", [self.tagNamesArray objectAtIndex:index],[[self.avgRatesArray objectAtIndex:index] integerValue]];
}

@end
