//
//  VEELookBackManager.h
//  Veespo
//
//  Created by Alessio Roberto on 17/04/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VEELookBackManager : NSObject

#pragma mark -
#pragma mark Shared Manager
+ (VEELookBackManager *)sharedManager;

#pragma mark Start User's Location
- (void)startLocation;

#pragma mark Stop User's Location
- (void)stopLocation;

@end
