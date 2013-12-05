//
//  VEMenuCell.h
//  Veespo
//
//  Created by Alessio Roberto on 22/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString const *kSidebarCellTextKey;
extern NSString const *kSidebarCellImageKey;

@interface VEMenuCell : UITableViewCell {
    UILabel* titleLabel;
    UIView* bgView;
    UIView* topSeparator;
    UIView* bottomSeparator;
    UIImageView* iconImageView;
    UIButton *iconButton;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *iconImage;

@end
