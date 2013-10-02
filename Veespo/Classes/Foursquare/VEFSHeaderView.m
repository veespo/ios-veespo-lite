//
//  VEFSHeaderView.m
//  Veespo
//
//  Created by Alessio Roberto on 26/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEFSHeaderView.h"

@implementation VEFSHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(42, 5, 236, 30)];
        imageView.image = [UIImage imageNamed:@"poweredByFoursquare_gray.png"];
        [imageView setBackgroundColor:[UIColor whiteColor]];
        [imageView setContentMode:UIViewContentModeCenter];
        [self addSubview:imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
