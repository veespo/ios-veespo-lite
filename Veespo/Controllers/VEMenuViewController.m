//
//  VEMenuViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 21/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEMenuViewController.h"
#import "GHRevealViewController.h"
#import "VEMenuCell.h"

@interface VEMenuViewController ()

@end

@implementation VEMenuViewController

- (id)initWithSidebarViewController:(GHRevealViewController *)sidebarVC
						withHeaders:(NSArray *)headers
					withControllers:(NSArray *)controllers
					  withCellInfos:(NSArray *)cellInfos {
	if (self = [super initWithNibName:nil bundle:nil]) {
		_sidebarVC = sidebarVC;
		_headers = headers;
		_controllers = controllers;
		_cellInfos = cellInfos;
		
		_sidebarVC.sidebarViewController = self;
		_sidebarVC.contentViewController = _controllers[0][0];
	}
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    UIColor* darkColor = UIColorFromRGB(0x1D7800);
    self.view.backgroundColor = UIColorFromRGB(0xDBDBDB);
    
    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds))
												  style:UITableViewStylePlain];
	_menuTableView.delegate = self;
	_menuTableView.dataSource = self;
	_menuTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	_menuTableView.backgroundColor = darkColor;
    _menuTableView.separatorColor = [UIColor clearColor];
	_menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _menuTableView.scrollEnabled = NO;
	[self.view addSubview:_menuTableView];
	[self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
	[_menuTableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
	if (scrollPosition == UITableViewScrollPositionNone) {
		[_menuTableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
	}
	_sidebarVC.contentViewController = _controllers[indexPath.section][indexPath.row];
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
    static NSString *CellIdentifier = @"VEMenuCell";
    VEMenuCell *cell = (VEMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VEMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	NSDictionary *info = _cellInfos[indexPath.section][indexPath.row];
	cell.title = info[kSidebarCellTextKey];
	cell.iconImage = info[kSidebarCellImageKey];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	_sidebarVC.contentViewController = _controllers[indexPath.section][indexPath.row];
	[_sidebarVC toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
