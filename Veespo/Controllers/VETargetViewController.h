//
//  VETargetViewController.h
//  Veespo
//
//  Created by Alessio Roberto on 11/10/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VETargetViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *targetList;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *token;

@end
