//
//  VEVenueCell.m
//  Veespo
//
//  Created by Alessio Roberto on 24/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEVenueCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation VEVenueCell

- (void)layoutSubviews {
    self.layer.cornerRadius = 8.0;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.0f;
    
    UIView *myContentView = self.contentView;
    [[myContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.venueIcon = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 30, 30)];
    [self.venueIcon setContentMode:UIViewContentModeScaleAspectFill];
    [myContentView addSubview:self.venueIcon];
    
    self.venueCategoryLbl = [[UILabel alloc] initWithFrame:CGRectMake(36, 9, 79, 15)];
    self.venueCategoryLbl.font = [UIFont fontWithName:@"Avenir-Light" size:10];
    self.venueCategoryLbl.numberOfLines = 2;
    self.venueCategoryLbl.minimumScaleFactor = 0.7;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        self.venueCategoryLbl.backgroundColor = [UIColor clearColor];
    [myContentView addSubview:self.venueCategoryLbl];
    
    UIView *borderTop = [[UIView alloc] initWithFrame:CGRectMake(0, 34, self.frame.size.width, 1)];
    borderTop.backgroundColor = [UIColor clearColor];
    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 35, self.frame.size.width, 1)];
    borderBottom.backgroundColor = [UIColor lightGrayColor];
    [myContentView addSubview:borderTop];
    [myContentView addSubview:borderBottom];
    
    self.venueNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, 115, 40)];
    self.venueNameLbl.font = [UIFont fontWithName:@"Avenir-Black" size:14];
    self.venueNameLbl.textAlignment = NSTextAlignmentCenter;
    self.venueNameLbl.numberOfLines = 2;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        self.venueNameLbl.backgroundColor = [UIColor clearColor];
    [myContentView addSubview:self.venueNameLbl];
    
    self.venueAddressLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 84, 115, 30)];
    self.venueAddressLbl.font = [UIFont fontWithName:@"Avenir-LightOblique" size:10];
    self.venueAddressLbl.textAlignment = NSTextAlignmentCenter;
    self.venueAddressLbl.numberOfLines = 2;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        self.venueAddressLbl.backgroundColor = [UIColor clearColor];
    [myContentView addSubview:self.venueAddressLbl];
}

@end
