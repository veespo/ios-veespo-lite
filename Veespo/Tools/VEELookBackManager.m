//
//  VEELookBackManager.m
//  Veespo
//
//  Created by Alessio Roberto on 17/04/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import "VEELookBackManager.h"

#import "VEEReachabilityManager.h"

#import <CoreLocation/CoreLocation.h>

@interface VEELookBackManager  () <CLLocationManagerDelegate> {
    NSDate *startUploadDate;
    NSTimer *pendingLocationsTimer;
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation VEELookBackManager

#pragma mark -
#pragma mark Default Manager
+ (VEELookBackManager *)sharedManager {
    static VEELookBackManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark -
#pragma Recording manager

- (void)startRecording
{
    if (IS_IPHONE_5) {
        [[Lookback_Weak lookback] setEnabled:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kVEEStartLookBackRecording object:self];
    }
}

- (void)stopRecording
{
    if (IS_IPHONE_5) {
        [[Lookback_Weak lookback] setEnabled:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:kVEEEndLookBackRecording object:self];
    }
}

#pragma mark Private Initialization
- (id)init {
    self = [super init];
    
    if (self) {
        // Automatically put an experience's URL on the user's pasteboard when recording ends and upload starts.
        [[NSNotificationCenter defaultCenter] addObserverForName:LookbackStartedUploadingNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            startUploadDate = [NSDate date];
            NSLog(@"============= Start LookBack Upload =============");
            NSLog(@"%@ - %@",[note userInfo][LookbackExperienceDestinationURLUserInfoKey], [note userInfo][LookbackExperienceStartedAtUserInfoKey]);
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kVEEFinishedUploading];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kVEEFinishedUploading object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            NSLog(@"============= Finished LookBack Upload =============");
            NSLog(@"%@",note);
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kVEEFinishedUploading];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(startLookBackRecording)
                                                     name:kVEEStartLookBackRecording
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(endLookBackRecording)
                                                     name:kVEEEndLookBackRecording
                                                   object:nil];
    }
    
    return self;
}

- (void)startLookBackRecording
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kVEEEndLookBackRecording];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)endLookBackRecording
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kVEEEndLookBackRecording];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kVEEFinishedUploading];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
