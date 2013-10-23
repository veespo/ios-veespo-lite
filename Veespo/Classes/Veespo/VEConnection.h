//
//  VEConnection.h
//  Veespo
//
//  Created by Alessio Roberto on 11/10/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VEConnection : NSObject

- (void)requestTargetList:(NSDictionary *)dataSet withBlock:(void(^)(id responseData))block;

@end
