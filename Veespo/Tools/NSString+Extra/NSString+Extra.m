//
//  NSString+Extra.m
//  Fimm
//
//  Created by The Coder on 3/16/12.
//  Copyright (c) 2012 Cleancode. All rights reserved.
//

#import "NSString+Extra.h"

@implementation NSString (Extra)

- (NSString *)stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding
{
	return  (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (__bridge CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (BOOL)checkIdString
{
    // Prima verifico che la stringa sia alfa numerica e non solo numerica
    if ([self areAllDigits]) {
        return NO;
    } else if ([self illegalChars]) {
        return NO;
    }
    return YES;
}

- (BOOL)areAllWhiteSpace
{
    NSString *trimString = [NSString stringWithString:self];
    trimString = [trimString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([trimString isEqualToString:@""])
        return YES;
    return NO;
}


#pragma mark - Private

- (BOOL)areAllDigits
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

- (BOOL)illegalChars
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789_-"] invertedSet];
    
    if ([self rangeOfCharacterFromSet:set].location != NSNotFound)
        return YES;
    else
        return NO;
}

@end
