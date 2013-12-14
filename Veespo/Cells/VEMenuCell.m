//
//  VEMenuCell.m
//  Veespo
//
//  Created by Alessio Roberto on 22/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEMenuCell.h"

NSString const *kSidebarCellTextKey = @"CellText";
NSString const *kSidebarCellImageKey = @"CellImage";

@implementation VEMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        bgView.backgroundColor = UIColorFromRGB(0x1D7800);
        
        topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 42, 320, 1)];
        topSeparator.backgroundColor = [UIColor clearColor];
        bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
        bottomSeparator.backgroundColor = UIColorFromRGB(0xBABABA);
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(46, 12, 251, 21)];
        self.title.textColor = [UIColor whiteColor];
        self.title.backgroundColor = [UIColor clearColor];
        
        self.iconImage = [[UIImageView alloc] init];
        self.iconImage.frame = CGRectMake(8, 7, 30, 30);

        [self.contentView addSubview:bgView];
        [self.contentView addSubview:topSeparator];
        [self.contentView addSubview:bottomSeparator];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.iconImage];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
