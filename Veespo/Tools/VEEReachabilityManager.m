//
//  VEEReachabilityManager.m
//  Veespo
//
//  Created by Alessio Roberto on 16/04/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import "VEEReachabilityManager.h"

#import "VEEReachability.h"

@implementation VEEReachabilityManager

#pragma mark -
#pragma mark Default Manager
+ (VEEReachabilityManager *)sharedManager {
    static VEEReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark -
#pragma mark Memory Management
- (void)dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable {
    return [[[VEEReachabilityManager sharedManager] reachability] isReachable];
}

+ (BOOL)isUnreachable {
    return ![[[VEEReachabilityManager sharedManager] reachability] isReachable];
}

+ (BOOL)isReachableViaWWAN {
    return [[[VEEReachabilityManager sharedManager] reachability] isReachableViaWWAN];
}

+ (BOOL)isReachableViaWiFi {
    return [[[VEEReachabilityManager sharedManager] reachability] isReachableViaWiFi];
}

#pragma mark -
#pragma mark Private Initialization
- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        self.reachability = [VEEReachability reachabilityWithHostname:@"www.google.com"];
        
        // Start Monitoring
        [self.reachability startNotifier];
    }
    
    return self;
}

@end
