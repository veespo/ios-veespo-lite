//
//  RassegnaCell.h
//  campoalpha
//
//  Created by Alessio Roberto on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RassegnaCell : UITableViewCell {
    UILabel     *_data;
    UILabel     *_events;
}

@property(nonatomic,retain) UILabel     *data;
@property(nonatomic,retain) UILabel     *events;

@end
