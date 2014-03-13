//
//  VEVisualView.h
//  VeespoFramework
//
//  Created by Alessio Roberto on 29/08/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VEVisualView : UIView
/**
 *    Update panel information.
 *
 *    @param average The average of the ratings given by the user.
 *    @param votes   The total number of tags that the user has voted.
 *    @param tags    The total number of tags for the target.
 */
- (void)updatePannel:(NSNumber *)average totalVotes:(NSInteger)votes totalTags:(NSInteger)tags;

@end
