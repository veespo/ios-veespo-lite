//
//  GiornoCell.m
//  campoalpha
//
//  Created by Alessio Roberto on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RassegnaCell.h"

@implementation RassegnaCell
@synthesize data = _data, events = _events;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
		_data = [[UILabel alloc] init];
		_data.backgroundColor = [UIColor clearColor];
        _data.textAlignment = NSTextAlignmentLeft;
		_data.font = [UIFont fontWithName:@"Avenir-Black" size:15];
        _data.adjustsFontSizeToFitWidth = NO;
        _data.numberOfLines = 2;
        
		_events = [[UILabel alloc] init];
		_events.backgroundColor = [UIColor clearColor];
        _events.textAlignment = NSTextAlignmentLeft;
		_events.font = [UIFont fontWithName:@"Avenir" size:12];
        _data.adjustsFontSizeToFitWidth = YES;

        [self.contentView addSubview: _data];
        [self.contentView addSubview: _events];
        
//        self.backgroundView         = [[[UIImageView alloc] init] autorelease];
//        self.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
//        ((UIImageView *)self.backgroundView).image         = [UIImage imageNamed:@"tableviewOFF@2x.png"];
//        ((UIImageView *)self.selectedBackgroundView).image = [UIImage imageNamed:@"tableviewON@2x.png"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame; //x, y, w, h
    
    frame = CGRectMake(25, 20, 270, 30);
    _data.frame = frame;
    
    frame = CGRectMake(25, 51, 270, 18);
    _events.frame = frame;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
