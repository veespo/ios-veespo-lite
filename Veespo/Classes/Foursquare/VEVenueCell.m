//
//  VEVenueCell.m
//  Veespo
//
//  Created by Alessio Roberto on 24/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEVenueCell.h"

@implementation VEVenueCell

- (void)layoutSubviews {
    UIView *myContentView = self.contentView;
    [[myContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.venueIcon = [[UIImageView alloc] initWithFrame:CGRectMake(49, 7, 30, 30)];
    [self.venueIcon setContentMode:UIViewContentModeScaleAspectFill];
    [self.venueIcon setBackgroundColor:[UIColor grayColor]];
    [myContentView addSubview:self.venueIcon];
    self.venueNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(4, 45, 121, 39)];
    self.venueNameLbl.font = [UIFont fontWithName:@"Avenir" size:12];
    self.venueNameLbl.numberOfLines = 2;
    [myContentView addSubview:self.venueNameLbl];
    self.venueDistanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(4, 94, 39, 16)];
    self.venueDistanceLbl.font = [UIFont fontWithName:@"Avenir" size:8];
    [myContentView addSubview:self.venueDistanceLbl];
}

@end
