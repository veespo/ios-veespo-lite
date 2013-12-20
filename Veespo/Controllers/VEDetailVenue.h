//
//  VEDetailVenue.h
//  Veespo
//
//  Created by Alessio Roberto on 02/10/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"
#import "MBProgressHUD.h"

@interface VEDetailVenue : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) FSVenue *venue;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *adressLabel;
@property (nonatomic, weak) IBOutlet UIButton *veespoButton;
@property (nonatomic, weak) IBOutlet UIImageView *venueImage;
@property (nonatomic, weak) IBOutlet UITableView *avgTableView;
@property (nonatomic, weak) IBOutlet UILabel *averageLabel;
@property (nonatomic, weak) IBOutlet UIImageView *averageImageView;

@end
