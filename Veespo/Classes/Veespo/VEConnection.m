//
//  VEConnection.m
//  Veespo
//
//  Created by Alessio Roberto on 11/10/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEConnection.h"
#import "AFNetworking.h"

@implementation VEConnection

#pragma mark - Public
- (void)requestTargetList:(NSDictionary *)dataSet withBlock:(void(^)(id responseData))block
{
    NSString *demoCode = [dataSet objectForKey:@"democode"];
    NSString *userId = [dataSet objectForKey:@"userid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/category/demo-code/%@", demoCode];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // Richiesta target
        [self getTarget:JSON[@"data"][@"reply"] withBlock:^(id responseData) {
            block(responseData[@"data"]);
        }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        block([NSDictionary dictionaryWithObject:@"Errore di connessione" forKey:@"error"]);
    }];
    
    [operation start];
}

#pragma mark - Private
- (void)getTarget:(NSString *)catId withBlock:(void(^)(id responseData))block
{
    NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/target-info/category/%@", catId];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        block(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        block([NSDictionary dictionaryWithObject:@"Errore di connessione" forKey:@"error"]);
    }];
    
    [operation start];
}

@end
