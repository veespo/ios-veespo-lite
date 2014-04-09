//
//  VEDetailVenue.h
//  Veespo
//
//  Created by Alessio Roberto on 02/10/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"

@interface VEDetailVenue : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) FSVenue *venue;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *adressLabel;
@property (nonatomic, weak) IBOutlet UIButton *veespoButton;
@property (nonatomic, weak) IBOutlet UIImageView *venueImage;
@property (nonatomic, weak) IBOutlet UITableView *avgTableView;
@property (nonatomic, weak) IBOutlet UILabel *averageLabel;
@property (nonatomic, weak) IBOutlet UILabel *headerTableView;
@property (weak, nonatomic) IBOutlet UIButton *directionButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uimageViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstShadowYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secondShadowYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerTableYConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameLabelYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *adressLabelYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *avrgLabelYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *baseLabelYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelHeaderYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *veespoButtonYConstraint;


- (IBAction)directionPressed:(id)sender;

@end
