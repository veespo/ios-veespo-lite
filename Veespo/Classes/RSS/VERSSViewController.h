//
//  VERSSViewController.h
//  Veespo
//
//  Created by Alessio Roberto on 24/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VERootViewController.h"
#import "MBProgressHUD.h"

@class VERSSParser;

@interface VERSSViewController : VERootViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    VERSSParser *rssParser;
    MBProgressHUD *HUD;
}

@end
