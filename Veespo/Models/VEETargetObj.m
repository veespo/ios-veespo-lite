//
//  VEETargetObj.m
//  Veespo
//
//  Created by Alessio Roberto on 09/05/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import "VEETargetObj.h"

@implementation VEETargetObj

- (id)initWithDictionary:(NSDictionary *)target
{
    self = [super init];
    
    if (self) {
        _targetId = target[@"target"];
        _desc1 = target[@"desc1"];
        _desc2 = target[@"desc2"];
    }
    
    return self;
}

@end
