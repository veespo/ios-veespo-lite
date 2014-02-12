//
//  VELeftMenuViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 13/12/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VELeftMenuViewController.h"

#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "VEMenuCell.h"


@interface VELeftMenuViewController ()

@end

@implementation VELeftMenuViewController

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
	
    self.view.backgroundColor = UIColorFromHex(0x231F20);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViewControllers:(NSArray *)controllers cellInfos:(NSArray *)cellInfos headers:(NSArray *)headers
{
    _controllers = controllers;
    _cellInfos = cellInfos;
    _headers = headers;
    
    [self setUpTableView];
}

#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return (_headers[section] == [NSNull null]) ? 0.0f : 21.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (section == 3) ? 21.0f : 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSObject *headerText = _headers[section];
	UIView *headerView = nil;
	if (headerText != [NSNull null]) {
		headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 21.0f)];
        headerView.backgroundColor = UIColorFromHex(0x231F20);
		
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
		textLabel.text = (NSString *) headerText;
		textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:([UIFont systemFontSize] * 0.8f)];
		textLabel.textColor = [UIColor whiteColor];
		textLabel.backgroundColor = [UIColor clearColor];
		[headerView addSubview:textLabel];
	}
	return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = nil;
	if (section == 3) {
		footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 21.0f)];
        footerView.backgroundColor = [UIColor clearColor];
		
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(footerView.bounds, 12.0f, 5.0f)];
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
		textLabel.text = [NSString stringWithFormat:@"v.%@", version];
		textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:([UIFont systemFontSize] * 0.8f)];
		textLabel.textColor = UIColorFromHex(0x231F20);
		textLabel.backgroundColor = [UIColor clearColor];
		[footerView addSubview:textLabel];
	}
	return footerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _headers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)_controllers[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VEMenuCell";
    VEMenuCell *cell = (VEMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VEMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
	NSDictionary *info = _cellInfos[indexPath.section][indexPath.row];
	cell.title.text = info[kSidebarCellTextKey];
	cell.iconImage.image = info[kSidebarCellImageKey];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // fix to by pass standard menu logic and open the widget
    if (indexPath.section == 3 && indexPath.row == 0)
        [self openVeespo];
    else {
        self.sidePanelController.centerPanel = _controllers[indexPath.section][indexPath.row];
        [self.sidePanelController setCenterPanelHidden:NO animated:YES duration:0.2f];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

- (void)setUpTableView
{
    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
												  style:UITableViewStylePlain];
	_menuTableView.delegate = self;
	_menuTableView.dataSource = self;
	_menuTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	_menuTableView.backgroundColor = [UIColor whiteColor];
    _menuTableView.separatorColor = [UIColor clearColor];
	_menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _menuTableView.scrollEnabled = NO;
	[self.view addSubview:_menuTableView];
}

- (void)openVeespo
{
#ifdef VEESPO
    VEAppDelegate *appDelegate = (VEAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *p = @{@"question": @{
                                @"text": [NSString stringWithFormat:NSLocalizedString(@"Veespo Question", nil), @"Veespo Lite"]
                                }
                        };
    
//    VEVeespoViewController *veespoViewController = [[VEVeespoViewController alloc] initWidgetWithToken:[appDelegate.tokens objectForKey:@"veespo_lite_app"]
//                                                                                                target:@"veespo_lite_iOS"
//                                                                                          parameters:p
//                                                                                           detailsView:nil
//                                                    ];
    
    VEVeespoViewController *veespoViewController = [[VEVeespoViewController alloc] initWidgetWithToken:[appDelegate.tokens objectForKey:@"veespo_lite_app"] target:@"veespo_lite_iOS" withQuestion:nil detailsView:nil];
    
    veespoViewController.closeVeespoViewController = ^(NSDictionary *data){
//        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%s: %@", __PRETTY_FUNCTION__, data]];
//        [Flurry logEvent:[NSString stringWithFormat:@"App Feedback: Veespo clodes with status %@", data]];
        [self dismissViewControllerAnimated:YES completion:nil];
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

@end
