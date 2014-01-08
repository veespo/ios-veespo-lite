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
#import "VEChartViewController.h"
#import "MBProgressHUD.h"

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
                
                [self.venueImage setImageWithURL:[NSURL URLWithString:urlStr]];
                
                UIImageView *shadow = [[UIImageView alloc] initWithFrame:self.venueImage.bounds];
                shadow.image = [UIImage imageNamed:@"ombra.png"];
                [self.venueImage addSubview:shadow];
                shadow = nil;
            }
        }
    }];
	
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"price_tag.png"]
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
    }
    
    self.title = self.venue.category;
    self.nameLabel.text = self.venue.name;
    self.adressLabel.text = self.venue.location.address;
    self.averageLabel.text = @"-";
    
    [self.veespoButton setTitle:NSLocalizedString(@"Feedback", nil) forState:UIControlStateNormal];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSMutableArray *tmpAvgArray = [NSMutableArray array];
    NSMutableArray *tmpNameArray = [NSMutableArray array];
    
    if (avgTargetsList.count < 5) {
        for (int i = 0; i < (5 - avgTargetsList.count); i++) {
            [tmpAvgArray addObject:[NSNumber numberWithInt:0]];
            [tmpNameArray addObject:@""];
        }
    }
    
    for (int i = 0; i < avgTargetsList.count; i++) {
        NSDictionary *dict = [avgTargetsList objectAtIndex:i];
        [tmpAvgArray addObject:[NSNumber numberWithFloat:roundf([dict[@"avg"] floatValue] * 5)]];
        [tmpNameArray addObject:dict[@"name"]];
    }
    chartViewController.avgRatesArray = tmpAvgArray;
    chartViewController.tagNamesArray = tmpNameArray;
    
    [self.navigationController pushViewController:chartViewController animated:YES];
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
                self.averageLabel.text = [NSString stringWithFormat:@"%.1f", [overall floatValue] * 5];
                avgTargetsList = [[NSArray alloc] initWithArray:result];
                [self.avgTableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    
    veespoViewController = [[VEVeespoViewController alloc]
                            initWidgetWithToken:_token
                            targetInfo:d
                            withQuestion:[NSString stringWithFormat:NSLocalizedString(@"Veespo Question", nil), self.venue.name]
                            detailsView:nil
                            ];
    
    veespoViewController.closeVeespoViewController = ^(NSDictionary *data){
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%s: %@", __PRETTY_FUNCTION__, data]];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 22.0f)];
    headerView.backgroundColor = UIColorFromHex(0xDBDBDB);
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
    textLabel.text = NSLocalizedString(@"Venue tags", nil);
    textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:([UIFont systemFontSize] * 0.7f)];
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:textLabel];
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
    title.textColor = [UIColor blackColor];
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

@end
