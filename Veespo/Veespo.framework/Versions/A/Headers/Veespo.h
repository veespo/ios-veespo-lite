//
//  Veespo.h
//  VeespoFramework
//
//  Created by Alessio Roberto on 19/03/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Veespo/VEVeespoViewController.h>
#import <Veespo/VEVeespoAPIWrapper.h>

@interface Veespo : NSObject

/**
 *    Init the Framework
 *
 *    @param apiKey    Veespo secret apikey.
 *    @param userId    ID of your user.
 *    @param partnerId The Veespo parter ID.
 *    @param lang      System languages.
 *    @param catsId    If you don't need tokens for all categories, you can pass a list with only categories you need. If you want all tokens this parameter is @b nil.
 *    @param test      @b YES if you want use Veespo's SandBox server for your test
 *    @param tokens    A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the result list and an error flag.
 */
+ (void)initVeespo:(NSString *)apiKey
            userId:(NSString *)userId
         partnerId:(NSString *)partnerId
          language:(NSString *)lang
        categories:(NSDictionary *)catsId
           testUrl:(BOOL)test
            tokens:(void(^)(id responseData, BOOL error))tokens;

/**
 *    Get Framework's version
 *
 *    @return A NSString that rapresent the Framework's version
 */
+ (NSString *)getFrameworkVersion;

@end
