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
	
    self.view.backgroundColor = UIColorFromRGB(0xDBDBDB);
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSObject *headerText = _headers[section];
	UIView *headerView = nil;
	if (headerText != [NSNull null]) {
		headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 21.0f)];
        headerView.backgroundColor = UIColorFromRGB(0xDBDBDB);
		
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
		textLabel.text = (NSString *) headerText;
		textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:([UIFont systemFontSize] * 0.8f)];
		textLabel.textColor = [UIColor colorWithRed:(125.0f/255.0f) green:(129.0f/255.0f) blue:(146.0f/255.0f) alpha:1.0f];
		textLabel.backgroundColor = [UIColor clearColor];
		[headerView addSubview:textLabel];
	}
	return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _headers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)_controllers[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"VEMenuCell";
//    VEMenuCell *cell = (VEMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[VEMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	NSDictionary *info = _cellInfos[indexPath.section][indexPath.row];
	cell.textLabel.text = info[kSidebarCellTextKey];
	cell.imageView.image = info[kSidebarCellImageKey];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.sidePanelController.centerPanel = _controllers[indexPath.section][indexPath.row];
    [self.sidePanelController setCenterPanelHidden:NO animated:YES duration:0.2f];
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
	_menuTableView.backgroundColor = UIColorFromRGB(0x1D7800);
    _menuTableView.separatorColor = [UIColor clearColor];
	_menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _menuTableView.scrollEnabled = NO;
	[self.view addSubview:_menuTableView];
}

@end
