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
        self.navigationController.navigationBar.tintColor = UIColorFromHex(0x231F20);
    } else {
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = UIColorFromHex(0x231F20);
    }
    
    self.title = NSLocalizedString(@"ESPN Top News", nil);
    self.view.backgroundColor = [UIColor whiteColor];
	
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
    newsTitleLbl.text = @"Serie A";
    newsTitleLbl.font = [UIFont fontWithName:@"Avenir-Heavy" size:13];

    [headerImageView addSubview:newsTitleLbl];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, appBounds.size.height - 50) style:UITableViewStylePlain];
    } else {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, appBounds.size.height - 30) style:UITableViewStylePlain];
    }
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
    [super viewWillAppear:animated];
    
    if (_dataSource.count == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSURL *url = [NSURL URLWithString:@"http://api.espn.com/v1/sports/soccer/ita.1/news/headlines/top/?apikey=t8hkx98mdft2mkuntmvpbwaf"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:15];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *responseData = [NSDictionary dictionaryWithDictionary:JSON];
            _dataSource = [NSMutableArray arrayWithArray:responseData[@"headlines"]];
            [_tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@", error.debugDescription);
        }];
        [operation start];
    }
    
    [Flurry logEvent:@"Sport News View"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [Flurry logEvent:@"Open News Detail"];
}


@end
