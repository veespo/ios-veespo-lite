//
//  VEVeespoTest.m
//  Veespo
//
//  Created by Alessio Roberto on 21/02/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VEConnection.h"
#import "VEFlickrConnection.h"

@interface VEVeespoTest : XCTestCase {
    VEConnection *connection;
    VEFlickrConnection *fconnection;
}

@end

@implementation VEVeespoTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    connection = [[VEConnection alloc] init];
    fconnection = [[VEFlickrConnection alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    connection = nil;
    fconnection = nil;
    [super tearDown];
}

- (void)testFlickr
{
    // Set the flag to YES
    __block BOOL waitingForBlock = YES;
    
    [fconnection getPhotosInSet:nil
                        success:^(NSArray *responseData) {
                            // Set the flag to NO to break the loop
                            waitingForBlock = NO;
                            NSLog(@"%@", responseData);
                            XCTAssertNil(responseData, @"Non è nil");
                        } failure:^(id error) {
                            // Set the flag to NO to break the loop
                            waitingForBlock = NO;
                            XCTAssertFalse(TRUE, @"Errore di connessione");
                        }];
    
    // Run the loop
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

- (void)testCounting
{
    NSString *token = @"utk-6e2d39c0-37d8-433e-8543-05d278ab5407";
    NSString *target = @"4d04e21ae8d859417f502ea6";
    NSInteger users = 6;
    
    // Set the flag to YES
    __block BOOL waitingForBlock = YES;
    
    [connection getCountRatingsForCategory:@"cibi" andTarget:target withToken:token success:^(id responseData) {
        // Set the flag to NO to break the loop
        waitingForBlock = NO;
        NSInteger result = [responseData[@"users"] integerValue];
        XCTAssertEqual(users, result, @"Numero di utenti errato");
    } failure:^(id error) {
        // Set the flag to NO to break the loop
        waitingForBlock = NO;
        XCTAssertFalse(TRUE, @"Errore di connessione");
    }];
    
    // Run the loop
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

- (void)testRatings
{
    NSString *token = @"utk-6e2d39c0-37d8-433e-8543-05d278ab5407";
    NSString *target = @"4d04e21ae8d859417f502ea6";
    NSUInteger tags = 29;
    
    // Set the flag to YES
    __block BOOL waitingForBlock = YES;
    
    [connection getRatingsForTarget:target andCategory:@"cibi" withToken:token success:^(NSDictionary *responseData) {
        // Set the flag to NO to break the loop
        waitingForBlock = NO;
        NSArray *result = responseData[@"ratings"];
        XCTAssertEqual(tags, result.count, @"Numero di tag errato");
    } failure:^(id error) {
        // Set the flag to NO to break the loop
        waitingForBlock = NO;
        XCTAssertFalse(TRUE, @"Errore di connessione");
    }];
    
    // Run the loop
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

- (void)testTagRating
{
    NSString *token = @"utk-6e2d39c0-37d8-433e-8543-05d278ab5407";
    NSString *target = @"4d04e21ae8d859417f502ea6";
    NSString *tag = @"fintotag-22a4d511-a2d4-4beb-a365-38fcc85ceebc";
    
    // Set the flag to YES
    __block BOOL waitingForBlock = YES;
    
    
    [connection getRatingTag:tag forTarget:target inCategory:@"cibi" withToken:token success:^(NSDictionary *responseData) {
        // Set the flag to NO to break the loop
        waitingForBlock = NO;
        XCTAssertNil(responseData, @"Non è nil");
    } failure:^(id error) {
        // Set the flag to NO to break the loop
        waitingForBlock = NO;
        XCTAssertFalse(TRUE, @"Errore di connessione");
    }];
    
    // Run the loop
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

@end
