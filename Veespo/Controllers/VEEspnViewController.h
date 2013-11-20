//
//  VEEspnViewController.h
//  Veespo
//
//  Created by Alessio Roberto on 25/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VERootViewController.h"
#import "MBProgressHUD.h"

@interface VEEspnViewController : VERootViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    MBProgressHUD *HUD;
}

@end
