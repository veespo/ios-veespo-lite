//
//  VELeftMenuViewController.h
//  Veespo
//
//  Created by Alessio Roberto on 13/12/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VELeftMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_menuTableView;
	NSArray *_headers;
	NSArray *_controllers;
	NSArray *_cellInfos;
}

- (void)setViewControllers:(NSArray *)controllers cellInfos:(NSArray *)cellInfos headers:(NSArray *)headers;

@end
