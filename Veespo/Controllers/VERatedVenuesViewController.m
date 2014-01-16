//
//  VERatedVenuesViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 05/12/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VERatedVenuesViewController.h"
#import "VEConnection.h"
#import "VEDetailVenue.h"
#import "Foursquare2.h"
#import "FSConverter.h"
#import "MBProgressHUD.h"

#import <AdSupport/AdSupport.h>

@interface VERatedVenuesViewController () {
    NSArray *targetsList;
}

@end

@implementation VERatedVenuesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    self.title = NSLocalizedString(@"Favorites", nil);
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    VEConnection *connection = [[VEConnection alloc] init];
    NSString *userId = nil;
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        userId = [NSString stringWithFormat:@"VeespoApp-%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"uuid"]];
    } else {
        userId = [NSString stringWithFormat:@"VeespoApp-%@", [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
    }
    
    VEAppDelegate *appDelegate = (VEAppDelegate *)[[UIApplication sharedApplication] delegate];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [connection requestTargetsForUser:userId withCategory:@"cibi" withToken:[appDelegate.tokens objectForKey:@"cibi"] blockResult:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            if (targetsList)
                targetsList = nil;
            
            NSArray *list = [[NSArray alloc] initWithArray:result];
            targetsList = [list sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSString *name1 = obj1[@"desc1"];
                NSString *name2 = obj2[@"desc1"];
                return [name1 compare:name2];
            }];
            [self.tableView reloadData];
            
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        } else {
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        }
    }];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return targetsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *headerImageView;
    UILabel *newsTitleLbl;
    UIView *headerBackground;
    UIView *headerView;
    
    headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
    headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
    headerBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    newsTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 300, 18)];
    
    headerView.backgroundColor = [UIColor clearColor];
    headerBackground.backgroundColor = UIColorFromHex(0x231F20);
    headerImageView.backgroundColor = [UIColor clearColor];
    headerImageView.image = [UIImage imageNamed:@"header_tabella.png"];
    [headerImageView setContentMode:UIViewContentModeScaleToFill];
    
    newsTitleLbl.textColor = [UIColor whiteColor];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        newsTitleLbl.backgroundColor = [UIColor clearColor];
    }
    newsTitleLbl.textAlignment = NSTextAlignmentCenter;
    newsTitleLbl.text = NSLocalizedString(@"No Votes", nil);
    newsTitleLbl.font = [UIFont fontWithName:@"Avenir-Heavy" size:13];
    
    [headerView addSubview:headerBackground];
    [headerView addSubview:headerImageView];
    [headerView addSubview:newsTitleLbl];
    
    return headerView;
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
    CGRect labelFrame = CGRectMake(10, 5, 240, 34);
    CGRect imageFrame = CGRectMake(250, 18.5, 57, 7);
	
	UILabel *title;
    UIImageView *rateImage;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.backgroundView = nil;
    cell.backgroundColor = [UIColor whiteColor];
    
    title = [[UILabel alloc] initWithFrame:labelFrame];
    title.font = [UIFont fontWithName:@"Avenir" size:15.0];
	title.tag = 1;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        title.backgroundColor = [UIColor clearColor];
    title.textColor = UIColorFromHex(0x6D6E70);
	[cell.contentView addSubview:title];
    
    rateImage = [[UIImageView alloc] initWithFrame:imageFrame];
    rateImage.tag = 2;
    rateImage.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:rateImage];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColorFromHex(0xFFFFFF) : UIColorFromHex(0xF1F1F2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self getCellContentView:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    cell.textLabel.text = [targetsList objectAtIndex:indexPath.row][@"desc1"];
    
    return cell;
}

#pragma mark - Table view data view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [Foursquare2 getDetailForVenue:[targetsList objectAtIndex:indexPath.row][@"target"] callback:^(BOOL success, id result) {
        NSDictionary *dict = [result valueForKeyPath:@"response.venue"];
        FSConverter *converter = [[FSConverter alloc] init];
        
        VEAppDelegate *appDelegate = (VEAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        VEDetailVenue *detail = [[VEDetailVenue alloc] initWithNibName:@"VEDetailVenue" bundle:nil];
        detail.venue = [converter converterToObject:dict];
        
        detail.token = [appDelegate.tokens objectForKey:@"cibi"];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        [self.navigationController pushViewController:detail animated:YES];
    }];
}

@end
