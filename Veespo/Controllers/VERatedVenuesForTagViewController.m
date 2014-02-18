//
//  VERatedVenuesForTagViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 04/02/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import "VERatedVenuesForTagViewController.h"
#import "VEConnection.h"
#import "MBProgressHUD.h"
#import "Foursquare2.h"
#import "FSConverter.h"
#import "FSVenue.h"
#import "VEDetailVenue.h"

static int const topVenue = 10;

@interface VERatedVenuesForTagViewController () {
    NSString *_category;
    NSString *_token;
    NSString *_tagid;
    NSString *_tagName;
    NSMutableArray *targetsListFoursquare;
    NSArray *targetsAvgList;
}

@end

@implementation VERatedVenuesForTagViewController

- (id)initWithStyle:(UITableViewStyle)style category:(NSString *)category tagId:(NSString *)tagid tagName:(NSString *)tagName token:(NSString *)token
{
    self = [super initWithStyle:style];
    if (self) {
        _category = category;
        _token = token;
        _tagid = tagid;
        _tagName = tagName;
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = _tagName;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self foursquareRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)foursquareRequest
{
    VEConnection *connection = [[VEConnection alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [connection requestAvgTargetsForTag:_tagid withCategory:_category withToken:_token blockResult:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            
            targetsAvgList = [[NSArray alloc] initWithArray:result];
            
            if (targetsListFoursquare)
                targetsListFoursquare = nil;
            targetsListFoursquare = [[NSMutableArray alloc] init];
            
            int totV = (targetsAvgList.count > topVenue) ? topVenue : targetsAvgList.count;
            
            for (int i = 0; i < totV; i++) {
                // Reqeust to Foursquare info about target
                [Foursquare2 getDetailForVenue:[targetsAvgList objectAtIndex:i][@"target"] callback:^(BOOL success, id result) {
                    if (success) {
                        NSDictionary *dict = [result valueForKeyPath:@"response.venue"];
                        FSConverter *converter = [[FSConverter alloc] init];
                        [targetsListFoursquare addObject:[converter converterToObject:dict]];
                    }
                    
                    if (i == totV - 1) {
                        [self.tableView reloadData];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }
                }];
            }
        } else {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
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
    return targetsListFoursquare.count;
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
    newsTitleLbl.text = NSLocalizedString(@"Top Venues", nil);
    newsTitleLbl.font = [UIFont fontWithName:@"Avenir-Heavy" size:13];
    
    [headerView addSubview:headerBackground];
    [headerView addSubview:headerImageView];
    [headerView addSubview:newsTitleLbl];
    
    return headerView;
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
    CGRect labelFrame = CGRectMake(10, 5, 235, 34);
    CGRect imageFrame = CGRectMake(240, 18.5, 57, 7);
	
	UILabel *title;
    UIImageView *rateImage;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
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
    static NSString *CellIdentifier = @"VenueCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self getCellContentView:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    FSVenue *venue = [targetsListFoursquare objectAtIndex:indexPath.row];
    NSDictionary *dict = [targetsAvgList objectAtIndex:indexPath.row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UIImageView *icon = (UIImageView *)[cell viewWithTag:2];
    
    label.text = venue.name;
    
    NSString *imageFileName = [NSString stringWithFormat:@"%.f.png", roundf([dict[@"avg"] floatValue] * 5)];
    icon.image = [UIImage imageNamed:imageFileName];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VEAppDelegate *appDelegate = (VEAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    VEDetailVenue *detail = [[VEDetailVenue alloc] initWithNibName:@"VEDetailVenue" bundle:nil];
    detail.venue = [targetsListFoursquare objectAtIndex:indexPath.row];
    
    detail.token = [appDelegate.tokens objectForKey:@"cibi"];
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    [self.navigationController pushViewController:detail animated:YES];
}

@end
