//
//  VEMenuCell.m
//  Veespo
//
//  Created by Alessio Roberto on 22/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEMenuCell.h"

@implementation VEMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        mainColor = [UIColor colorWithRed:47.0/255 green:168.0/255 blue:228.0/255 alpha:.8f];
        darkColor = UIColorFromRGB(0x1D7800);
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//    if(selected) {
//        bgView.backgroundColor = mainColor;
//        titleLabel.textColor = [UIColor blackColor];
//    }
//    else {
//        bgView.backgroundColor = darkColor;
//        titleLabel.textColor = [UIColor whiteColor];
//    }
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIView *myContentView = self.contentView;
    [[myContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bgView.backgroundColor = darkColor;
    [myContentView addSubview:bgView];
    
    topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 42, 320, 1)];
    topSeparator.backgroundColor = [UIColor clearColor];
    bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    bottomSeparator.backgroundColor = UIColorFromRGB(0x6E6E6E);
    [myContentView addSubview:topSeparator];
    [myContentView addSubview:bottomSeparator];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 12, 251, 21)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    [myContentView addSubview:titleLabel];
}

#pragma mark - Constants
NSString const *kSidebarCellTextKey = @"CellText";
NSString const *kSidebarCellImageKey = @"CellImage";

@end
