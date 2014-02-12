//
//  VERatedVenuesForTagViewController.h
//  Veespo
//
//  Created by Alessio Roberto on 04/02/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VERatedVenuesForTagViewController : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style category:(NSString *)category tagId:(NSString *)tagid tagName:(NSString *)tagName token:(NSString *)token;

@end
