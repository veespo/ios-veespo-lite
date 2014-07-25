//
//  VEAppDelegate.m
//  Veespo
//
//  Created by Alessio Roberto on 20/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEAppDelegate.h"

#import "JASidePanelController.h"

#import "VELeftMenuViewController.h"
#import "VEMenuCell.h"
#import "VEFSViewController.h"
#import "VERSSViewController.h"
#import "VEEspnViewController.h"
#import "Foursquare2.h"
#import "VEHomeViewController.h"
#import "VEELookBackManager.h"
#import "VEEReachabilityManager.h"

#pragma mark - Private Interface
@implementation VEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [VEEReachabilityManager sharedManager];
    [VEELookBackManager sharedManager];
    
    [self setUpApi];
    
    NSString *UUID = [[NSUserDefaults standardUserDefaults] objectForKey:kVEEUserUniqueID];
    if (!UUID) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        UUID = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
        
        [[NSUserDefaults standardUserDefaults] setObject:UUID forKey:kVEEUserUniqueID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    // Check old history version
    NSDictionary *history = [[NSUserDefaults standardUserDefaults] objectForKey:kVEEUserCategoriesHistory];
    if (history) {
        NSArray *keys = [history allKeys];
        if ([[history objectForKey:[keys objectAtIndex:0]] isKindOfClass:[NSString class]]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kVEEUserCategoriesHistory];
        }
    }
    
    // Side Panel
    [self setUpSidePanel];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // Check old history version
    NSDictionary *history = [[NSUserDefaults standardUserDefaults] objectForKey:kVEEUserCategoriesHistory];
    if (history) {
        NSArray *keys = [history allKeys];
        if ([[history objectForKey:[keys objectAtIndex:0]] isKindOfClass:[NSString class]]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kVEEUserCategoriesHistory];
        }
    }
    
    if (self.tokens == nil)
        [self checkVeespoTokens];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)checkVeespoTokens
{
#ifdef VEESPO
    NSString *keysPath = [[NSBundle mainBundle] pathForResource:kVEKeysFileName ofType:@"plist"];
    if (!keysPath) {
        NSLog(@"To use API make sure you have a Veespo-Keys.plist with the Identifier in your project");
        return;
    }
    
    NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:keysPath];
    [self setUpVeespo:keys];
#endif
}

#pragma mark - Private methods
#pragma mark - Side Panel
- (void)setUpSidePanel
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
    
    NSArray *headers = @[
                         @"Veespo Lite",
                         NSLocalizedString(@"Around me", nil),
                         NSLocalizedString(@"News", nil),
                         NSLocalizedString(@"About us", nil)
                         ];
	NSArray *controllers = @[
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[VEHomeViewController alloc] init]]
                                 ],
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[VEFSViewController alloc] init]]
                                 ],
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[VERSSViewController alloc] init]],
                                 [[UINavigationController alloc] initWithRootViewController:[[VEEspnViewController alloc] init]]
                                 ],
                             @[[[UINavigationController alloc] initWithRootViewController:[[VEHomeViewController alloc] init]]]
                             ];
    NSArray *cellInfos = @[
                           @[
                               @{kSidebarCellImageKey:[UIImage imageNamed:@"home.png"], kSidebarCellTextKey:@"Home"},
                               ],
                           @[
                               @{kSidebarCellImageKey:[UIImage imageNamed:@"shop.png"], kSidebarCellTextKey:NSLocalizedString(@"Venues", nil)},
                               ],
                           @[
                               @{kSidebarCellImageKey:[UIImage imageNamed:@"electronics.png"], kSidebarCellTextKey:NSLocalizedString(@"Tech News", nil)},
                               @{kSidebarCellImageKey:[UIImage imageNamed:@"football.png"], kSidebarCellTextKey:NSLocalizedString(@"Sport News", nil)},
                               ],
                           @[
                               @{kSidebarCellImageKey:[UIImage imageNamed:@"icona_vota_app.png"], kSidebarCellTextKey:NSLocalizedString(@"App Feedback", nil)}
                               ]
                           ];
    
    VELeftMenuViewController *menuController = [[VELeftMenuViewController alloc] init];
    [menuController setViewControllers:controllers cellInfos:cellInfos headers:headers];
    
    self.viewController.leftPanel = menuController;
    self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[VEHomeViewController alloc] init]];
    self.viewController.rightPanel = nil;
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
}

#pragma mark - API

- (void)setUpApi
{
    NSString *keysPath = [[NSBundle mainBundle] pathForResource:kVEKeysFileName ofType:@"plist"];
    if (!keysPath) {
        NSLog(@"To use API make sure you have a Veespo-Keys.plist with the Identifier in your project");
        return;
    }
    
    NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:keysPath];
    [self setUpFoursquare:keys];
    
#ifdef TESTFLIGHT
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:keys[kVEFlurryApiKey]];
    [TestFlight takeOff:keys[kVETestFlightKey]];
#endif
    
    [Lookback_Weak setupWithAppToken:keys[kVEELoockBackApiKey]];
    [Lookback_Weak lookback].shakeToRecord = NO;
    [Lookback_Weak lookback].userIdentifier = [[UIDevice currentDevice] name];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LookbackAudioEnabledSettingsKey];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LookbackCameraEnabledSettingsKey];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LookbackAutosplitSettingsKey];
}

- (void)setUpFoursquare:(NSDictionary *)keys
{
    [Foursquare2 setupFoursquareWithClientId:keys[kVEFoursquareKey]
                                      secret:keys[kVEFoursquareSecret]
                                 callbackURL:@"testapp123://foursquare"];
}

- (void)setUpVeespo:(NSDictionary *)keys
{
#ifdef VEESPO
    NSDictionary *categories = @{
                                 @"categories":@[
                                         @{@"cat": @"veespo_lite_app"},
                                         @{@"cat": @"cibi"},
                                         @{@"cat": @"news"}
                                         ]
                                 };
    NSString *userId;
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:kVEEUserNameKey]) {
        userId = [[NSUserDefaults standardUserDefaults] stringForKey:kVEEUserNameKey];
    } else {
        userId = [NSString stringWithFormat:@"VeespoLiteApp-%@", [[NSUserDefaults standardUserDefaults] stringForKey:kVEEUserUniqueID]];
    }
    
    [Veespo initVeespo:keys[kVEVeespoApiKey]
                userId:userId
             partnerId:@"alessio"
              language:[[NSLocale preferredLanguages] objectAtIndex:0]
            categories:categories
               testUrl:NO
                tokens:^(id responseData, BOOL error) {
                    if (error == NO) {
                        self.tokens = [[NSDictionary alloc] initWithDictionary:responseData];
                    } else {
                        self.tokens = nil;
                        NSLog(@"%@", responseData);
                    }
                }
     ];
#endif
}

@end
