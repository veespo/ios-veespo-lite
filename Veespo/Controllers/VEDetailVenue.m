//
//  VEDetailVenue.m
//  Veespo
//
//  Created by Alessio Roberto on 02/10/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEDetailVenue.h"
#import "Foursquare2.h"
#import "UIImageView+AFNetworking.h"
#import "VEConnection.h"
#import "VERatedVenuesViewController.h"
#import "VERatedVenuesForTagViewController.h"
#import "VEChartViewController.h"
#import "MBProgressHUD.h"
#import "VEDataChart.h"

@interface VEDetailVenue () {
    NSArray *avgTargetsList;
}

@end

@implementation VEDetailVenue


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
    
    [self loadAverageVotes];
    
    [Foursquare2 getDetailForVenue:self.venue.venueId callback:^(BOOL success, id result) {
        if (success) {
            NSDictionary *dict = [result valueForKeyPath:@"response.venue"];
            // Get first photo in first group
            if ([dict[@"photos"][@"groups"] count] > 0) {
                NSDictionary *group = [dict[@"photos"][@"groups"] objectAtIndex:0];
                NSDictionary *item = [group[@"items"] objectAtIndex:0];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@500x500%@", item[@"prefix"], item[@"suffix"]];
                
                [self.venueImage setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default_image_venue"]];
                
                UIImageView *shadow = [[UIImageView alloc] initWithFrame:self.venueImage.bounds];
                shadow.image = [UIImage imageNamed:@"ombra.png"];
                [self.venueImage addSubview:shadow];
                shadow = nil;
            }
        }
    }];
	
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    /*
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"price_tag_white.png"]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(openVenuesRatedView)
                                                  ];
    } else {
        
        UIBarButtonItem *ratedButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"price_tag.png"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(openVenuesRatedView)
                                        ];
        
        UIBarButtonItem *chartButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bar_chart.png"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(openChartView)
                                        ];
        
        self.navigationItem.rightBarButtonItems = @[ratedButton, chartButton];
         
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"price_tag.png"]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(openVenuesRatedView)
                                                  ];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    */
    
    [self.veespoButton setImage:[UIImage imageNamed:NSLocalizedString(@"Veespo Button", nil)] forState:UIControlStateNormal];
    
    self.title = self.venue.category;
    self.nameLabel.text = self.venue.name;
    self.adressLabel.text = self.venue.location.address;
    self.averageLabel.text = @"0.0";
    self.headerTableView.text = NSLocalizedString(@"Venue tags", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Check if Veespo is reary
    if ([_token isEqualToString:@""] || _token == nil) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.veespoButton.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.veespoButton.enabled = YES;
    }
    
//    [Flurry logEvent:@"Detail Venue View"];
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

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.uimageViewHeightConstraint.constant =
    [UIScreen mainScreen].bounds.size.height > 480.0f ? 205 : 165;
    self.firstShadowYConstraint.constant = [UIScreen mainScreen].bounds.size.height > 480.0f ? 95 : 55;
    self.secondShadowYConstraint.constant = [UIScreen mainScreen].bounds.size.height > 480.0f ? 149 : 109;
    self.tableViewConstraint.constant = [UIScreen mainScreen].bounds.size.height > 480.0f ? 231 : 191;
    self.tableViewYConstraint.constant = [UIScreen mainScreen].bounds.size.height > 480.0f ? 271 : 231;
    self.headerTableYConstraint.constant = [UIScreen mainScreen].bounds.size.height > 480.0f ? 203 : 163;
    self.nameLabelYConstraint.constant = [UIScreen mainScreen].bounds.size.height > 480.0f ? 103 : 63;
    self.adressLabelYConstraint.constant = [UIScreen mainScreen].bounds.size.height > 480.0f ? 127 : 87;
    self.avrgLabelYConstraint.constant = [UIScreen mainScreen].bounds.size.height > 480.0f ? 106 : 66;
    self.baseLabelYConstraint.constant = [UIScreen mainScreen].bounds.size.height > 480.0f ? 118 : 78;
    self.veespoButtonYConstraint.constant = [UIScreen mainScreen].bounds.size.height > 480.0f ? 161 : 121;
    self.labelHeaderYConstraint.constant = [UIScreen mainScreen].bounds.size.height > 480.0f ? 211 : 171;
}

#pragma mark - Veespo

- (void)openVenuesRatedView
{
    VERatedVenuesViewController *ratedViewController = [[VERatedVenuesViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:ratedViewController animated:YES];
}

- (void)openChartView
{
    VEChartViewController *chartViewController = [[VEChartViewController alloc] init];
    
    chartViewController.tagsArray = avgTargetsList;
    
    [self.navigationController pushViewController:chartViewController animated:YES];
    
//    [Flurry logEvent:@"Open Chart"];
}

- (void)loadAverageVotes
{
    if ([_token isEqualToString:@""] || _token == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                        message:NSLocalizedString(@"Veespo Error", nil)
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        VEConnection *connection = [[VEConnection alloc] init];
        [connection requestAverageForTarget:self.venue.venueId withCategory:@"cibi" withToken:_token blockResult:^(id result, id overall) {
            if ([result isKindOfClass:[NSArray class]]) {
                if (((NSArray*)result).count > 0) {
                    // Convert value to factor 5
                    float av = [overall floatValue] * 5;
                    // Scale to 10-0 value (pos value from 6 to 10)
                    av = (av + 5) / 2;
                    
                    self.averageLabel.text = [NSString stringWithFormat:@"%.1f", av];
                    
                    VEDataChart *dataChart = [[VEDataChart alloc] init];
                    avgTargetsList = [[NSArray alloc] initWithArray:[dataChart frequencyTagsOrder:result balanced:NO]];
                }
                
                [self.avgTableView reloadData];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            } else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:[result objectForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

- (IBAction)openVeespo:(id)sender
{
#ifdef VEESPO
    VEVeespoViewController *veespoViewController = nil;
    
    NSString *desc2 = (_venue.location.address) ? (NSString *)_venue.location.address : (NSString *)_venue.location.distance;
    
    NSDictionary *d = @{
                        @"local_id": self.venue.venueId, @"desc1": self.venue.name, @"desc2": desc2, @"lang": [[NSLocale preferredLanguages] objectAtIndex:0]
                        };
    
    NSDictionary *p = @{@"question": @{
                                @"text": [NSString stringWithFormat:NSLocalizedString(@"Veespo Question", nil), self.venue.name],
                                @"category": @"cibi"
                                }
                        };
    
//    veespoViewController = [[VEVeespoViewController alloc]
//                            initWidgetWithToken:_token
//                            targetInfo:d
//                            parameters:p
//                            detailsView:nil
//                            key1:self.venue.category
//                            key2:self.venue.country
//                            key3:self.venue.city
//                            key4:self.venue.postalCode
//                            key5:nil
//                            version:nil
//                            ];
    
    veespoViewController.closeVeespoViewController = ^(NSDictionary *data){
//        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%s: %@", __PRETTY_FUNCTION__, data]];
//        [Flurry logEvent:[NSString stringWithFormat:@"Venue Detail: Veespo clodes with status %@", data]];
        [self dismissViewControllerAnimated:YES completion:^{
            [self loadAverageVotes];
        }];
    };
    
    [veespoViewController showWidget:^(NSDictionary *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                        message:NSLocalizedString(@"Veespo Error", nil)
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Veespo Error: %@", error);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
#endif
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
    return avgTargetsList.count;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headerView = headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 37.0f)];
//    headerView.backgroundColor = [UIColor clearColor];
//    UIView *topBorderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 30.5f)];
//    topBorderView.backgroundColor = UIColorFromHex(0x221e1f);
//    [headerView addSubview:topBorderView];
//    
//    UIImageView *backGround = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 37.0f)];
//    backGround.image = [UIImage imageNamed:@"header_tabella"];
//    [headerView addSubview:backGround];
//    
//    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
//    textLabel.text = NSLocalizedString(@"Venue tags", nil);
//    textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:13.0f];
//    textLabel.textColor = [UIColor whiteColor];
//    textLabel.backgroundColor = [UIColor clearColor];
//    [headerView addSubview:textLabel];
//    
//	return headerView;
//}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self getCellContentView:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [avgTargetsList objectAtIndex:indexPath.row];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UIImageView *icon = (UIImageView *)[cell viewWithTag:2];
    
    label.text = [NSString stringWithFormat:@"%@", dict[@"name"]];
    
    NSString *imageFileName = [NSString stringWithFormat:@"%.f.png", roundf([dict[@"avg"] floatValue] * 5)];
    icon.image = [UIImage imageNamed:imageFileName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColorFromHex(0xFFFFFF) : UIColorFromHex(0xF1F1F2);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [avgTargetsList objectAtIndex:indexPath.row];
    
    VERatedVenuesForTagViewController *newViewController = [[VERatedVenuesForTagViewController alloc] initWithStyle:UITableViewStylePlain category:@"cibi" tagId:dict[@"tag"] tagName:dict[@"name"] token:_token];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    [self.navigationController pushViewController:newViewController animated:YES];
}

@end
