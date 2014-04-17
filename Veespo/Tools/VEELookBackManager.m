//
//  VEELookBackManager.m
//  Veespo
//
//  Created by Alessio Roberto on 17/04/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import "VEELookBackManager.h"

#import "VEEReachabilityManager.h"

#import <Lookback/Lookback.h>
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
#pragma mark Private Initialization
- (id)init {
    self = [super init];
    
    if (self) {
        // Automatically put an experience's URL on the user's pasteboard when recording ends and upload starts.
        [[NSNotificationCenter defaultCenter] addObserverForName:LookbackStartedUploadingNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            startUploadDate = [NSDate date];
            NSLog(@"============= Start LookBack Upload =============");
            NSLog(@"%@ - %@",[note userInfo][LookbackExperienceDestinationURLUserInfoKey], [note userInfo][LookbackExperienceStartedAtUserInfoKey]);
            
            
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

- (void)startLocation
{
    
    if ([VEEReachabilityManager isReachableViaWiFi] == YES && startUploadDate && [[NSUserDefaults standardUserDefaults] boolForKey:kVEEEndLookBackRecording]) {
        NSLog(@"============= Applicazione in chiusura, ma non ci sono le condizioni per avviare update posizione =============");
        [self startLookBackRecording];
        startUploadDate = nil;
    } else if ([VEEReachabilityManager isReachableViaWiFi] == NO && [[NSUserDefaults standardUserDefaults] boolForKey:kVEEEndLookBackRecording]) {
        if (startUploadDate)
            startUploadDate = nil;
        
        NSLog(@"============= Start location in background =============");
        
        [self startStandardUpdates];
    }
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

- (void)stopLocation
{
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"============= Stop location in background =============");
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (abs(howRecent) < 60.0 && !startUploadDate) {
        // If the event is recent, do something with it.
        ([VEEReachabilityManager isReachableViaWiFi]) ? NSLog(@"WiFi ON") : NSLog(@"WiFi OFF");
    } else if (abs(howRecent) < 5.0) {
        ([VEEReachabilityManager isReachableViaWiFi]) ? NSLog(@"WiFi ON") : NSLog(@"WiFi OFF");
        // Set a movement threshold for new events.
        self.locationManager.distanceFilter = 1000; // meters
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    }
    
    CGFloat timeout = 60.0f;
    if(startUploadDate && fabs([startUploadDate timeIntervalSinceNow]) > timeout) {
        NSLog(@"============= Sono passati %f minuti dall'avvio del upload =============", timeout/60.0f);
        [self stopLocation];
        startUploadDate = nil;
        // Reset recording flag
        [self startLookBackRecording];
    }
}

@end
