//
//  NSString+Extra.h
//  Fimm
//
//  Created by The Coder on 3/16/12.
//  Copyright (c) 2012 Cleancode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extra)

- (NSString *)stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding;
- (BOOL)checkIdString;
- (BOOL)areAllWhiteSpace;

@end
