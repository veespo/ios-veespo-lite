//
//  VETargetViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 11/10/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VETargetViewController.h"

#import <Lookback/Lookback.h>

@interface VETargetViewController () {
    NSMutableArray *target;
}

@end

@implementation VETargetViewController

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
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.navigationController.navigationBar.tintColor = UIColorFromHex(0x231F20);
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Navbar"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"NavbarShadow"]];
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = UIColorFromHex(0x231F20);
    }

    target = [[NSMutableArray alloc] init];
    
    for (NSDictionary *tar in _targetList) {
       [target addObject:tar];
    }
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [Flurry logEvent:@"Target List View"];
//}

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
    newsTitleLbl.text = NSLocalizedString(@"Target List", nil);
    newsTitleLbl.font = [UIFont fontWithName:@"Avenir-Heavy" size:13];
    
    [headerView addSubview:headerBackground];
    [headerView addSubview:headerImageView];
    [headerView addSubview:newsTitleLbl];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return target.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColorFromHex(0xFFFFFF) : UIColorFromHex(0xF1F1F2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSDictionary *dict = [target objectAtIndex:indexPath.row];
    cell.textLabel.text = dict[@"desc1"];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:17];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef VEESPO
    NSDictionary *dict = [target objectAtIndex:indexPath.row];
    
    NSDictionary *p = @{@"question": @{
                                @"text": NSLocalizedString(@"Veespo Question", nil)
                                }
                        };
    
    VEVeespoViewController *veespoViewController = [[VEVeespoViewController alloc] initWidgetWithToken:self.token target:dict[@"target"] targetParameters:nil parameters:p detailsView:nil];
    
    veespoViewController.closeVeespoViewController = ^(NSDictionary *data){
        [self dismissViewControllerAnimated:YES completion:^{
            [[Lookback_Weak lookback] setEnabled:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kVEEEndLookBackRecording object:self];
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
        [self dismissViewControllerAnimated:YES completion:^{
            [[Lookback_Weak lookback] setEnabled:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:kVEEEndLookBackRecording object:self];
        }];
    }];
    
    [[Lookback_Weak lookback] setEnabled:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kVEEStartLookBackRecording object:self];
#endif

}

@end
