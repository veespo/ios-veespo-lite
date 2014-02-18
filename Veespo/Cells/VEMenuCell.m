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
        bgView.backgroundColor = [UIColor whiteColor];
        
        topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 42, 320, 1)];
        topSeparator.backgroundColor = [UIColor clearColor];
        bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
        bottomSeparator.backgroundColor = UIColorFromHex(0xBABABA);
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(46, 12, 251, 21)];
        self.title.textColor = UIColorFromHex(0x231F20);
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [UIFont fontWithName:@"Avenir" size:17];
        
        self.iconImage = [[UIImageView alloc] init];
        self.iconImage.frame = CGRectMake(5.5, 9.5, 25, 25);

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
