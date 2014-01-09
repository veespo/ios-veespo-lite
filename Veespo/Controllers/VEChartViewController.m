//
//  VEChartViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 03/01/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import "VEChartViewController.h"
#import "VEDataChart.h"

static int const max = 6;

@interface VEChartViewController () {
    UILabel *tagNameLabel;
    JBBarChartView *barChartView;
    
    VEDataChart *dataChart;
    
    int negCount;
    int otherCount;
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
    
    tagNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 300, 90)];
    tagNameLabel.numberOfLines = 0;
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

- (void)setTagsArray:(NSArray *)tagsArray
{
    dataChart = [[VEDataChart alloc] init];
    NSArray *tmp = [dataChart averangeTagsOrder:tagsArray balanced:YES];
    _tagsArray = tmp;
}

#pragma mark - JBBarChartViewDelegate

- (NSInteger)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSInteger)index
{
    NSDictionary *dict = [self.tagsArray objectAtIndex:index];
    NSNumber *value = [NSNumber numberWithFloat:roundf([dict[@"avg"] floatValue] * 10)];
    return [value integerValue];
}

#pragma mark - JBBarChartViewDataSource

- (NSInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return self.tagsArray.count; // number of bars in chart
}

- (UIView *)barViewForBarChartView:(JBBarChartView *)barChartView atIndex:(NSInteger)index
{
    UIView *barView = [[UIView alloc] init];
    barView.backgroundColor = ([[[self.tagsArray objectAtIndex:index] objectForKey:@"connotation"] isEqualToString:@"NEGATIVE"]) ? UIColorFromHex(0x870013) : UIColorFromHex(0x1D7800);
    return barView;
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSInteger)index
{
    if ([[[self.tagsArray objectAtIndex:index] objectForKey:@"avg"] floatValue] > 0) {
        tagNameLabel.text = [NSString stringWithFormat:@"%@: %.1f", [[self.tagsArray objectAtIndex:index] objectForKey:@"name"],[[[self.tagsArray objectAtIndex:index] objectForKey:@"avg"] floatValue] * 5];
    } else
        tagNameLabel.text = @"";
}

@end
