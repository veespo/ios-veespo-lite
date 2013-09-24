//
//  VEUser.h
//  Veespo
//
//  Created by Alessio Roberto on 22/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VEUser : NSObject

@property (nonatomic, strong, readonly) NSDictionary *history;
@property (nonatomic, strong) NSDictionary *accessData;
@property (nonatomic, strong) NSString *userName;

@end
