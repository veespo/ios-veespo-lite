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

@interface VEDetailVenue () {
    MBProgressHUD *HUD;
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
	
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Feedback", nil) style:UIBarButtonItemStylePlain target:self action:@selector(openVeespo:)];
    
    if ([_token isEqualToString:@""] || _token == nil) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    self.nameLabel.text = self.venue.name;
    self.adressLabel.text = self.venue.location.address;
    self.nameLabel.shadowColor = [UIColor lightGrayColor];
    self.adressLabel.shadowColor = [UIColor whiteColor];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [HUD show:YES];
    [Foursquare2 getDetailForVenue:self.venue.venueId callback:^(BOOL success, id result) {
        NSDictionary *dict = [result valueForKeyPath:@"response.venue"];
        // Get first photo in first group
        if ([dict[@"photos"][@"groups"] count] > 0) {
            NSDictionary *group = [dict[@"photos"][@"groups"] objectAtIndex:0];
            NSDictionary *item = [group[@"items"] objectAtIndex:0];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@500x500%@", item[@"prefix"], item[@"suffix"]];
            
            [self.venueImage setImageWithURL:[NSURL URLWithString:urlStr]];
        }
        
        VEConnection *connection = [[VEConnection alloc] init];
        
        [connection requestAverageForTarget:self.venue.venueId withCategory:@"cibi" withToken:_token blockResult:^(id result) {
            NSLog(@"%@", result);
            avgTargetsList = [[NSArray alloc] initWithArray:result];
            [self.avgTableView reloadData];
        }];
        
        [HUD hide:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openVeespo:(id)sender
{
#ifdef VEESPO
    VEVeespoViewController *veespoViewController = nil;
    
    NSDictionary *d = @{
                        @"local_id": self.venue.venueId, @"desc1": self.venue.name, @"desc2": self.venue.category, @"lang": [[NSLocale preferredLanguages] objectAtIndex:0]
                        };
    
    veespoViewController = [[VEVeespoViewController alloc]
                            initWidgetWithToken:_token
                            targetInfo:d
                            withQuestion:[NSString stringWithFormat:@"Cosa ne pensi di %@", self.venue.name]
                            detailsView:nil
                            ];
    
    veespoViewController.closeVeespoViewController = ^(NSDictionary *data){
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%s: %@", __PRETTY_FUNCTION__, data]];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [veespoViewController showWidget:^(NSDictionary *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messagio di debug"
                                                        message:[NSString stringWithFormat:@"Error %@", error]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [avgTargetsList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %f", dict[@"name"], [dict[@"avg"] floatValue]];
    
    return cell;
}

@end
