//
//  VEEspnViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 25/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEEspnViewController.h"
#import "RassegnaCell.h"
#import "WebViewController.h"
#import "AFNetworking.h"

@interface VEEspnViewController ()

@end

@implementation VEEspnViewController

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
    newsTitleLbl.text = @"Serie A";
    newsTitleLbl.font = [UIFont fontWithName:@"Avenir" size:17];
    [headerView addSubview:newsTitleLbl];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, appBounds.size.height - 20) style:UITableViewStylePlain];
    } else {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, 320, appBounds.size.height + 64) style:UITableViewStylePlain];
    }
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:[UIColor whiteColor]];
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
        NSURL *url = [NSURL URLWithString:@"http://api.espn.com/v1/sports/soccer/ita.1/news/headlines/top/?apikey=t8hkx98mdft2mkuntmvpbwaf"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:15];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *responseData = [NSDictionary dictionaryWithDictionary:JSON];
            _dataSource = [NSMutableArray arrayWithArray:responseData[@"headlines"]];
            [_tableView reloadData];
            [HUD hide:YES afterDelay:1];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"%@", error.debugDescription);
        }];
        [operation start];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.events.text = [[_dataSource objectAtIndex:indexPath.row] objectForKey: @"headline"];
    cell.data.text = [[_dataSource objectAtIndex:indexPath.row] objectForKey:@"title"];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *links = [[_dataSource objectAtIndex:indexPath.row] valueForKey:@"links"];
    links = [links valueForKey:@"mobile"];
    NSString * storyLink = [links valueForKey:@"href"];
    
    // clean up the link - get rid of spaces, returns, and tabs...
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@" " withString:@""];
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@"	" withString:@""];
    
    VEAppDelegate *appDelegate = (VEAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    WebViewController *wvc = [[WebViewController alloc] init];
    [wvc setUrl:[NSURL URLWithString:storyLink]];
    [wvc setHeadline:[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"headline"]];
    [wvc setNewsTitle:[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"title"]];
    [wvc setLocal_id:[NSString stringWithFormat:@"ESPN_SERIEA_%@",[[_dataSource objectAtIndex:indexPath.row] valueForKey:@"id"]]];
    [wvc setToken:[appDelegate.tokens objectForKey:@"news"]];
    [self.navigationController pushViewController:wvc animated:YES];

}


@end
