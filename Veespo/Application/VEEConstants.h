//
//  VEEConstants.h
//  Veespo
//
//  Created by Alessio Roberto on 17/04/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

// API's Keys
static NSString * const kVEFoursquareKey = @"Foursquare key";
static NSString * const kVEFoursquareSecret = @"Foursquare secret";
static NSString * const kVETestFlightKey = @"TestFlight Key";
static NSString * const kVEKeysFileName = @"Veespo-Keys";
static NSString * const kVEVeespoApiKey = @"Veespo Api Key";
static NSString * const kVEFlurryApiKey = @"Flurry Key";
static NSString * const kVEELoockBackApiKey = @"LookBack Key";

// NSUserDefaults keys
static NSString * const kVEEUserNameKey = @"kVEEUserNameKey";
static NSString * const kVEEUserUniqueID = @"uuid";
static NSString * const kVEEUserCategoriesHistory = @"history";
static NSString * const kVEEStartLocationUpdateBackground = @"kVEEStartLocationUpdateBackground";

// NSNotificationCenter keys
static NSString * const kVEEGoToForeground = @"kVeespoGoToForeground";
static NSString * const kVEEGoToBackground = @"kVeespoGoToBackground";
static NSString * const kVEEEndLookBackRecording = @"kVEEEndLookBackRecording";
static NSString * const kVEEStartLookBackRecording = @"kVEEStartLookBackRecording";
static NSString * const kVEEFinishedUploading = @"com.thirdcog.lookback.notification.finishedUploading";

@interface VEEConstants : NSObject

@end
