//
//  VEMenuCell.m
//  Veespo
//
//  Created by Alessio Roberto on 22/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEMenuCell.h"

@implementation VEMenuCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIView *myContentView = self.contentView;
    [[myContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bgView.backgroundColor = UIColorFromRGB(0x1D7800);
    [myContentView addSubview:bgView];
    
    topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 42, 320, 1)];
    topSeparator.backgroundColor = [UIColor clearColor];
    bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    bottomSeparator.backgroundColor = UIColorFromRGB(0xBABABA);
    [myContentView addSubview:topSeparator];
    [myContentView addSubview:bottomSeparator];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 12, 251, 21)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.title;
    [myContentView addSubview:titleLabel];
}

#pragma mark - Constants
NSString const *kSidebarCellTextKey = @"CellText";
NSString const *kSidebarCellImageKey = @"CellImage";

@end
