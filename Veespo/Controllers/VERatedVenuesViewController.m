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
    
    self.title = NSLocalizedString(@"Favorites", nil);

    VEConnection *connection = [[VEConnection alloc] init];
    NSString *userId = nil;
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        userId = [NSString stringWithFormat:@"VeespoApp-%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"uuid"]];
    } else {
        userId = [NSString stringWithFormat:@"VeespoApp-%@", [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
    }
    VEAppDelegate *appDelegate = (VEAppDelegate *)[[UIApplication sharedApplication] delegate];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } else {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSString *alertString = [result objectForKey:@"error"];
            
            if (alertString == nil) {
                alertString = NSLocalizedString(@"No Votes", nil);
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Foursquare2 getDetailForVenue:[targetsList objectAtIndex:indexPath.row][@"target"] callback:^(BOOL success, id result) {
        NSDictionary *dict = [result valueForKeyPath:@"response.venue"];
        FSConverter *converter = [[FSConverter alloc] init];
        
        VEAppDelegate *appDelegate = (VEAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        VEDetailVenue *detail = [[VEDetailVenue alloc] initWithNibName:@"VEDetailVenue" bundle:nil];
        detail.venue = [converter converterToObject:dict];
        
        detail.token = [appDelegate.tokens objectForKey:@"cibi"];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.navigationController pushViewController:detail animated:YES];
    }];
}

@end
