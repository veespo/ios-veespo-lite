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
//    if (IS_IPHONE_5) {
        [[Lookback_Weak lookback] setEnabled:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kVEEStartLookBackRecording object:self];
//    }
}

- (void)stopRecording
{
//    if (IS_IPHONE_5) {
        [[Lookback_Weak lookback] setEnabled:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:kVEEEndLookBackRecording object:self];
//    }
}

#pragma mark -
#pragma mark Start User's Location
- (void)startLocation
{
    if ([VEEReachabilityManager isReachableViaWiFi] == YES && [[NSUserDefaults standardUserDefaults] boolForKey:kVEEEndLookBackRecording] == YES && [[NSUserDefaults standardUserDefaults] boolForKey:kVEEFinishedUploading] == YES) {
        NSLog(@"============= Applicazione in chiusura, ma non ci sono le condizioni per avviare update posizione =============");
        [self startLookBackRecording];
        startUploadDate = nil;
    } else if ([[NSUserDefaults standardUserDefaults] boolForKey:kVEEEndLookBackRecording] == YES && [[NSUserDefaults standardUserDefaults] boolForKey:kVEEFinishedUploading] == NO) {
        if (startUploadDate)
            startUploadDate = nil;
        
        NSLog(@"============= Start location in background =============");
        
        [self startStandardUpdates];
    } else if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground && [[NSUserDefaults standardUserDefaults] boolForKey:kVEEEndLookBackRecording] == YES && [[NSUserDefaults standardUserDefaults] boolForKey:kVEEFinishedUploading] == NO) {
        NSLog(@"============= Start location in background =============");
        
        [self startStandardUpdates];
    }
}

#pragma mark Stop User's Location
- (void)stopLocation
{
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"============= Stop location in background =============");
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
                                                 selector:@selector(startLocation)
                                                     name:kVEEGoToBackground
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopLocation)
                                                     name:kVEEGoToForeground
                                                   object:nil];
        
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

#pragma mark CLLocation Manager

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

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)startStandardUpdates
{
    // Set a movement threshold for new events.
    //self.locationManager.distanceFilter = 500; // meters
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.locationManager startUpdatingLocation];
}

- (void)startSignificantChangeUpdates
{
    [self.locationManager startMonitoringSignificantLocationChanges];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    
//    CLLocation* location = [locations lastObject];
//    NSDate* eventDate = location.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if ([VEEReachabilityManager isReachableViaWiFi] == YES) {
        // Set a movement threshold for new events.
        self.locationManager.distanceFilter = 500; // meters
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    
//    if (abs(howRecent) < 60.0 && !startUploadDate) {
//        // If the event is recent, do something with it.
//        ([VEEReachabilityManager isReachableViaWiFi]) ? NSLog(@"============= WiFi ON =============") : NSLog(@"============= WiFi OFF =============");
//    } else if (abs(howRecent) < 5.0 && startUploadDate) {
//        ([VEEReachabilityManager isReachableViaWiFi]) ? NSLog(@"============= WiFi ON =============") : NSLog(@"============= WiFi OFF =============");
//        // Set a movement threshold for new events.
//        self.locationManager.distanceFilter = 200; // meters
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kVEEFinishedUploading] == YES) {
        [self stopLocation];
        startUploadDate = nil;
        // Reset recording flag
        [self startLookBackRecording];
    }
    
    CGFloat timeout = 180.0f;
    if(startUploadDate && fabs([startUploadDate timeIntervalSinceNow]) > timeout) {
        NSLog(@"============= Sono passati %.1f minuti dall'avvio del upload =============", timeout/60.0f);
        [self stopLocation];
        startUploadDate = nil;
        // Reset recording flag
        [self startLookBackRecording];
    }
}

@end
