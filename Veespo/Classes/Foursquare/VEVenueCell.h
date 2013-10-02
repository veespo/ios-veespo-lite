//
//  VEVenueCell.h
//  Veespo
//
//  Created by Alessio Roberto on 24/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VEVenueCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *venueIcon;
@property (nonatomic, strong) UILabel *venueNameLbl;
@property (nonatomic, strong) UILabel *venueAddressLbl;
@property (nonatomic, strong) UILabel *venueCategoryLbl;

@end
