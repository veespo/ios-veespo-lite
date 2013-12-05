//
//  VEAppDelegate.m
//  Veespo
//
//  Created by Alessio Roberto on 20/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEAppDelegate.h"
#import "GHRevealViewController.h"
#import "VEMenuViewController.h"
#import "VERootViewController.h"
#import "VEMenuCell.h"
#import "VEViewController.h"
#import "VEFSViewController.h"
#import "VERSSViewController.h"
#import "VEEspnViewController.h"
#import "Foursquare2.h"

#import <AdSupport/AdSupport.h>

static NSString * const kVEFoursquareKey = @"Foursquare key";
static NSString * const kVEFoursquareSecret = @"Foursquare secret";
static NSString * const kVETestFlightKey = @"TestFlight Key";
static NSString * const kVEKeysFileName = @"Veespo-Keys";
static NSString * const kVEVeespoApiKey = @"Veespo Api Key";

#pragma mark - Private Interface
@interface VEAppDelegate ()
@property (nonatomic, strong) GHRevealViewController *revealController;
@property (nonatomic, strong) VEMenuViewController *menuController;
@end

@implementation VEAppDelegate
@synthesize revealController, menuController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpApi];
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        [NSUserDefaults resetStandardUserDefaults];
        NSString *dateKey = @"Data Key";
        NSDate *lastRead = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:dateKey];
        if (!lastRead) {
            NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], dateKey, nil];
            // sync the defaults to disk
            [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:[VEAppDelegate uuid] forKey:@"uuid"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:dateKey];
    }

    [self configSidebarController];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
        self.window.tintColor = UIColorFromRGB(0x1D7800);
    
    self.window.rootViewController = self.revealController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)configSidebarController
{
    self.revealController = [[GHRevealViewController alloc] init];
    RevealBlock revealBlock = ^(){
		[self.revealController toggleSidebar:!self.revealController.sidebarShowing
									duration:kGHRevealSidebarDefaultAnimationDuration];
	};
    
    NSArray *headers = @[
                         @"VEESPO",
                         @"OTHER"
                         ];
	NSArray *controllers = @[
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[VEViewController alloc] initWithTitle:@"Home" withRevealBlock:revealBlock]]
                                 ],
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[VEFSViewController alloc] initWithTitle:NSLocalizedString(@"Venues", nil) withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[VERSSViewController alloc] initWithTitle:NSLocalizedString(@"Tech News", nil) withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[VEEspnViewController alloc] initWithTitle:NSLocalizedString(@"ESPN Top News", nil) withRevealBlock:revealBlock]]
                                 ]
                             ];
    NSArray *cellInfos = @[
                           @[
                               @{kSidebarCellImageKey:[UIImage imageNamed:@"home.png"], kSidebarCellTextKey:@"Home"},
                               ],
                           @[
                               @{kSidebarCellImageKey:[UIImage imageNamed:@"shop.png"], kSidebarCellTextKey:NSLocalizedString(@"Venues", nil)},
                               @{kSidebarCellImageKey:[UIImage imageNamed:@"electronics.png"], kSidebarCellTextKey:NSLocalizedString(@"Tech News", nil)},
                               @{kSidebarCellImageKey:[UIImage imageNamed:@"football.png"], kSidebarCellTextKey:NSLocalizedString(@"Sport News", nil)},
                               ]
                           ];
    
    self.menuController = [[VEMenuViewController alloc] initWithSidebarViewController:self.revealController
																		  withHeaders:headers
																	  withControllers:controllers
																		withCellInfos:cellInfos];
}

+ (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge NSString *)uuidStringRef;
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
    [self setUpVeespo:keys];
    [TestFlight takeOff:keys[kVETestFlightKey]];
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
                                         @{@"cat": @"cibi"},
                                         @{@"cat": @"localinotturni"},
                                         @{@"cat": @"news"}
                                         ]
                                 };
    NSString *userId = nil;
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        userId = [NSString stringWithFormat:@"VeespoApp-%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"uuid"]];
    } else {
        userId = [NSString stringWithFormat:@"VeespoApp-%@", [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
    }
    
    [Veespo initVeespo:keys[kVEVeespoApiKey]
                userId:userId
             partnerId:@"apple"
              language:[[NSLocale preferredLanguages] objectAtIndex:0]
            categories:categories
               testUrl:YES
                tokens:^(id responseData, BOOL error) {
                    if (error == NO) {
                        self.tokens = [[NSDictionary alloc] initWithDictionary:responseData];
                        NSLog(@"%@ /n %@", userId, self.tokens);
                    }
                }
     ];
#endif
}

@end
