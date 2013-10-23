//
//  VEDetailVenue.h
//  Veespo
//
//  Created by Alessio Roberto on 02/10/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"

@interface VEDetailVenue : UIViewController

@property (nonatomic, strong) FSVenue *venue;
@property (nonatomic, strong) NSString *token;

@end
