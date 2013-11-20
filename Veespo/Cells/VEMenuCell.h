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
    UIColor* mainColor;
    UIColor* darkColor;
    UILabel* titleLabel;
    UIView* bgView;
    UIView* topSeparator;
    UIView* bottomSeparator;
    UIImageView* iconImageView;
}

@property (nonatomic, strong) NSString *title;

@end
