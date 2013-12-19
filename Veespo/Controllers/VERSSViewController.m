//
//  VERSSViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 24/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VERSSViewController.h"
#import "VERSSParser.h"
#import "RassegnaCell.h"
#import "WebViewController.h"

@interface VERSSViewController ()

@end

@implementation VERSSViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x1D7800);
    } else {
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x1D7800);
    }
    
    _dataSource = [[NSMutableArray alloc] init];
    
    CGRect appBounds = [UIScreen mainScreen].bounds;
    
    UIView *headerView;
    UILabel *newsTitleLbl;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
        newsTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 300, 25)];
    } else {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        newsTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 300, 25)];
    }
    [headerView setBackgroundColor:UIColorFromRGB(0x1D7800)];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        newsTitleLbl.font = [UIFont fontWithName:UIFontTextStyleHeadline size:20];
    }
    newsTitleLbl.textColor = [UIColor whiteColor];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        newsTitleLbl.backgroundColor = [UIColor clearColor];
    }
    newsTitleLbl.textAlignment = NSTextAlignmentCenter;
    newsTitleLbl.text = @"TechCrunch - Startups";
    [headerView addSubview:newsTitleLbl];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, appBounds.size.height - 20) style:UITableViewStylePlain];
    else
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, 320, appBounds.size.height + 64) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setShowsVerticalScrollIndicator:YES];
    _tableView.tableHeaderView = headerView;
    [_tableView reloadData];
    
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_dataSource.count == 0) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        [HUD show:YES];
        
        rssParser = [[VERSSParser alloc] init];
        __weak VERSSViewController *wSelf = self;
        rssParser.parseResult = ^(NSMutableArray *results){
            NSLog(@"%d", results.count);
            [wSelf reloadTableView:results];
        };
        [rssParser parseXMLFileAtURL:@"http://feeds.feedburner.com/TechCrunch/startups"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTableView:(NSMutableArray *)data
{
    _dataSource = data;
    NSLog(@"%d", _dataSource.count);
    [_tableView reloadData];
    [HUD hide:YES afterDelay:1];
}

#pragma mark - TableView mths

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_dataSource count];
}

// Customize the height of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	RassegnaCell *cell = (RassegnaCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[RassegnaCell alloc] initWithFrame:CGRectZero];
	}
	
	// Set up the cell
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
    cell.data.text = [[_dataSource objectAtIndex: storyIndex] objectForKey: @"date"];
    cell.events.text = [[_dataSource objectAtIndex:storyIndex] objectForKey:@"title"];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
    
    NSString * storyLink = [[_dataSource objectAtIndex: storyIndex] objectForKey: @"link"];
    
    // clean up the link - get rid of spaces, returns, and tabs...
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@" " withString:@""];
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@"	" withString:@""];
    
    NSString *dateString = [[_dataSource objectAtIndex: storyIndex] objectForKey: @"date"];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"	" withString:@""];
    
    //Detect.
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingAllTypes error:nil];
    [detector enumerateMatchesInString:dateString
                               options:kNilOptions
                                 range:NSMakeRange(0, [dateString length])
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
     {
         time_t unixTime = (time_t) [result.date timeIntervalSince1970];
         VEAppDelegate *appDelegate = (VEAppDelegate *)[[UIApplication sharedApplication] delegate];
         
         WebViewController *wvc = [[WebViewController alloc] init];
         [wvc setUrl:[NSURL URLWithString:storyLink]];
         [wvc setLocal_id:[NSString stringWithFormat:@"rss_tech_%ld", unixTime]];
         [wvc setToken:[appDelegate.tokens objectForKey:@"news"]];
         NSString *title = [[_dataSource objectAtIndex:indexPath.row] valueForKey:@"title"];
         title = [title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         title = [title stringByReplacingOccurrencesOfString:@"	" withString:@""];
         [wvc setNewsTitle:title];
         [wvc setHeadline:title];
         [self.navigationController pushViewController:wvc animated:YES];
     }];
    
    
    
}


@end
