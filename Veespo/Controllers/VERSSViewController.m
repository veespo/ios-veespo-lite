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
#import "MBProgressHUD.h"

@interface VERSSViewController ()

@end

static NSString * const feed = @"http://feeds.feedburner.com/TechCrunch/startups";

@implementation VERSSViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.navigationController.navigationBar.tintColor = UIColorFromHex(0x231F20);
    } else {
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = UIColorFromHex(0x231F20);
    }
    
    self.title = @"TechCrunch";
    
    _dataSource = [[NSMutableArray alloc] init];
    
    CGRect appBounds = [UIScreen mainScreen].bounds;
    
    UIImageView *headerImageView;
    UILabel *newsTitleLbl;
    headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, 322, 38)];
    newsTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 300, 18)];
    
    headerImageView.backgroundColor = [UIColor clearColor];
    headerImageView.image = [UIImage imageNamed:@"header_tabella.png"];
    [headerImageView setContentMode:UIViewContentModeScaleToFill];
    
    newsTitleLbl.textColor = [UIColor whiteColor];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        newsTitleLbl.backgroundColor = [UIColor clearColor];
    }
    newsTitleLbl.textAlignment = NSTextAlignmentCenter;
    newsTitleLbl.text = @"Startups";
    newsTitleLbl.font = [UIFont fontWithName:@"Avenir-Heavy" size:13];
    
    [headerImageView addSubview:newsTitleLbl];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, appBounds.size.height - 50) style:UITableViewStylePlain];
    else
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, appBounds.size.height - 30) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setShowsVerticalScrollIndicator:YES];
    [_tableView reloadData];
    
    [self.view addSubview:_tableView];
    [self.view addSubview:headerImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_dataSource.count == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        rssParser = [[VERSSParser alloc] init];
        
        __block VERSSViewController *wSelf = self;
        rssParser.parseResult = ^(NSMutableArray *results){
            [wSelf reloadTableView:results];
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [rssParser parseXMLFileAtURL:feed];
        });
    }
    
//    [Flurry logEvent:@"Tech News"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTableView:(NSMutableArray *)data
{
    _dataSource = data;
    [_tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - TableView mths

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (_dataSource.count > 0)?[_dataSource count]:0;
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
    
    NSString *dateString = [[_dataSource objectAtIndex: storyIndex] objectForKey: @"date"];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"	" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    cell.data.text = dateString;
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
    
    VEAppDelegate *appDelegate = (VEAppDelegate *)[[UIApplication sharedApplication] delegate];
    WebViewController *wvc = [[WebViewController alloc] init];
    [wvc setUrl:[NSURL URLWithString:storyLink]];
    [wvc setToken:[appDelegate.tokens objectForKey:@"news"]];
    NSString *title = [[_dataSource objectAtIndex:indexPath.row] valueForKey:@"title"];
    title = [title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    title = [title stringByReplacingOccurrencesOfString:@"	" withString:@""];
    [wvc setNewsTitle:title];
    [wvc setHeadline:title];
    
    //Detect.
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingAllTypes error:nil];
    [detector enumerateMatchesInString:dateString
                               options:kNilOptions
                                 range:NSMakeRange(0, [dateString length])
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
     {
         time_t unixTime = (time_t) [result.date timeIntervalSince1970];
         [wvc setLocal_id:[NSString stringWithFormat:@"rss_tech_%ld", unixTime]];
     }];
    
    [self.navigationController pushViewController:wvc animated:YES];
//    [Flurry logEvent:@"Open News Detail"];
}


@end
