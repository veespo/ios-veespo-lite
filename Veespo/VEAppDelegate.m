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
#import "VEVeespoViewController.h"
#import "VEFSViewController.h"
#import "VERSSViewController.h"
#import "VEEspnViewController.h"
#import "Foursquare2.h"

#pragma mark - Private Interface
@interface VEAppDelegate ()
@property (nonatomic, strong) GHRevealViewController *revealController;
@property (nonatomic, strong) VEMenuViewController *menuController;
@end

@implementation VEAppDelegate
@synthesize revealController, menuController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Foursquare2 setupFoursquareWithClientId:@"AXC1A3NOVLLF4UL3SPJHXNEMXADRG3Z1OJRSCRQL0C0I5ZOV"
                                      secret:@"QQFISLPK5YXPHURAGKJTWI2DT1KQHM2CGVYBXMRKPAU1VKEJ"
                                 callbackURL:@"testapp123://foursquare"];
    
	self.revealController = [[GHRevealViewController alloc] initWithNibName:nil bundle:nil];
    RevealBlock revealBlock = ^(){
		[self.revealController toggleSidebar:!self.revealController.sidebarShowing
									duration:kGHRevealSidebarDefaultAnimationDuration];
	};
    
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
//                                                                           fontWithName:@"Avenir-Black" size:15], NSFontAttributeName,
//                                [UIColor blackColor], NSForegroundColorAttributeName, nil];
//    
//    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];

    NSArray *headers = @[
                         @"VEESPO",
                         @"OTHER"
    ];
	NSArray *controllers = @[
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[VEVeespoViewController alloc] initWithTitle:@"Veespo" withRevealBlock:revealBlock]]
                                 ],
                             @[
                                 [[UINavigationController alloc] initWithRootViewController:[[VEFSViewController alloc] initWithTitle:@"FourSquare" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[VERSSViewController alloc] initWithTitle:@"News: Tecnologia" withRevealBlock:revealBlock]],
                                 [[UINavigationController alloc] initWithRootViewController:[[VEEspnViewController alloc] initWithTitle:@"ESPN Top News" withRevealBlock:revealBlock]]
                                 ]
    ];
    NSArray *cellInfos = @[
                           @[
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey:@"Home"},
                               ],
                           @[
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey:@"FourSquare"},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey:@"News: Tecnologia"},
                               @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey:@"News: Sport"},
                            ]
    ];
    
    self.menuController = [[VEMenuViewController alloc] initWithSidebarViewController:self.revealController
																		  withHeaders:headers
																	  withControllers:controllers
																		withCellInfos:cellInfos];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
        self.window.tintColor = [UIColor greenColor];
    self.window.rootViewController = self.revealController;
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
