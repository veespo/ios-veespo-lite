//
//  VEEReachabilityManager.h
//  Veespo
//
//  Created by Alessio Roberto on 16/04/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

@class VEEReachability;

@interface VEEReachabilityManager : NSObject

@property (strong, nonatomic) VEEReachability *reachability;

#pragma mark -
#pragma mark Shared Manager
+ (VEEReachabilityManager *)sharedManager;

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

@end
