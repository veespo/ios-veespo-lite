//
//  VEVeespoTest.m
//  Veespo
//
//  Created by Alessio Roberto on 21/02/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VEConnection.h"

@interface VEVeespoTest : XCTestCase {
    VEConnection *connection;
}

@end

@implementation VEVeespoTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    connection = [[VEConnection alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    connection = nil;
    [super tearDown];
}

- (void)testConnection
{
    NSString *token = @"utk-cd5d64ea-6668-4ea0-b22c-c266a43c16f7";
    NSString *target = @"4d04e21ae8d859417f502ea6";
    NSInteger users = 5;
    
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

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

@end
