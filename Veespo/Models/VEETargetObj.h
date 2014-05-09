//
//  VEETargetObj.h
//  Veespo
//
//  Created by Alessio Roberto on 09/05/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//


@interface VEETargetObj : NSObject

@property (nonatomic, strong) NSString *targetId;
@property (nonatomic, strong) NSString *desc1;
@property (nonatomic, strong) NSString *desc2;
@property (assign) BOOL voted;

- (id)initWithDictionary:(NSDictionary *)target;

@end
