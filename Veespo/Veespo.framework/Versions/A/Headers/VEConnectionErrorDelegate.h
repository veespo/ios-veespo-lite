//
//  VEConnectionErrorDelegate.h
//  VeespoFramework
//
//  Created by Alessio Roberto on 3/23/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *    Internal protocol, to manage errors connection.
 */
@protocol VEConnectionErrorDelegate <NSObject>
@required
- (void)noRetryConnection;
@end