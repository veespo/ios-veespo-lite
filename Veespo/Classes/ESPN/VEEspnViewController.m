//
//  VEEspnViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 25/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEEspnViewController.h"
#import "RassegnaCell.h"
#import "WebVC.h"
#import "AFNetworking.h"

@interface VEEspnViewController ()

@end

@implementation VEEspnViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _dataSource = [[NSMutableArray alloc] init];
    CGRect appBounds = [UIScreen mainScreen].bounds;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    UILabel *newsTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 300, 25)];
    newsTitleLbl.font = [UIFont fontWithName:UIFontTextStyleHeadline size:20];
    newsTitleLbl.textColor = [UIColor whiteColor];
    newsTitleLbl.textAlignment = NSTextAlignmentCenter;
    newsTitleLbl.text = @"Serie A";
    [headerView addSubview:newsTitleLbl];
    
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
    cell.events.text = [[_dataSource objectAtIndex:indexPath.row] objectForKey: @"linkText"];
    cell.data.text = [[_dataSource objectAtIndex:indexPath.row] objectForKey:@"title"];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic
    
    NSDictionary *links = [[_dataSource objectAtIndex:indexPath.row] valueForKey:@"links"];
    links = [links valueForKey:@"mobile"];
    NSString * storyLink = [links valueForKey:@"href"];
    
    // clean up the link - get rid of spaces, returns, and tabs...
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@" " withString:@""];
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@"	" withString:@""];
    
    //NSLog(@"link: %@", storyLink);
    
    WebVC *wvc = [[WebVC alloc] init];
    [wvc setUrl:[NSURL URLWithString:storyLink]];
    [self.navigationController pushViewController:wvc animated:YES];
    // open in Safari
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:storyLink]];
}


@end
