//
//  VEAppDelegate.h
//  Veespo
//
//  Created by Alessio Roberto on 20/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JASidePanelController;

@interface VEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDictionary *tokens;

@property (strong, nonatomic) JASidePanelController *viewController;

@end
