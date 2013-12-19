//
//  VEMenuViewController.h
//  Veespo
//
//  Created by Alessio Roberto on 21/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

@class GHRevealViewController;

@interface VEMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	UITableView *_menuTableView;
	NSArray *_headers;
	NSArray *_controllers;
	NSArray *_cellInfos;
}

- (id)initWithSidebarViewController:(GHRevealViewController *)sidebarVC
						withHeaders:(NSArray *)headers
					withControllers:(NSArray *)controllers
					  withCellInfos:(NSArray *)cellInfos;

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath
					animated:(BOOL)animated
			  scrollPosition:(UITableViewScrollPosition)scrollPosition;

@end
