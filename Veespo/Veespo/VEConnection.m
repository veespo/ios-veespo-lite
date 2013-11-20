#import "VEConnection.h"
#import "AFNetworking.h"

@implementation VEConnection

#pragma mark - Public
- (void)requestTargetList:(NSDictionary *)dataSet withBlock:(void(^)(id responseData, NSString *token))block
{
    NSString *demoCode = [dataSet objectForKey:@"democode"];
    NSString *userId = [dataSet objectForKey:@"userid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://sandbox.veespo.com/v1/category/demo-code/%@", demoCode];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *error = JSON[@"error"];
        
        if (error != nil) {
            block([NSDictionary dictionaryWithObject:NSLocalizedString(@"Wrong Code", nil) forKey:@"error"], nil);
        } else {
            // Richiesta user token
            NSString *urlStr = [NSString stringWithFormat:@"http://sandbox.veespo.com/v1/user-token/demo-code/%@?user=%@", demoCode, userId];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSMutableURLRequest *brequest = [NSMutableURLRequest requestWithURL:url];
            [brequest setHTTPMethod:@"GET"];
            [brequest setTimeoutInterval:10];
            __block NSString *catId = JSON[@"data"][@"category"];
            AFJSONRequestOperation *boperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:brequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                // Richiesta target
                [self getTarget:catId userToken:JSON[@"data"][@"reply"] withBlock:^(id responseData) {
                    NSDictionary *resp = [NSDictionary dictionaryWithObjectsAndKeys:catId, @"category",  responseData[@"data"], @"targets", nil];
                    block(resp, JSON[@"data"][@"reply"]);
                }];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                block([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"], nil);
            }];
            [boperation start];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        block([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"], nil);
    }];
    
    [operation start];
}

#pragma mark - Private
- (void)getTarget:(NSString *)catId userToken:(NSString *)uTk withBlock:(void(^)(id responseData))block
{
    // /v1/user-token/demo-code/EWFQ?user=alessio
    NSString *urlStr = [NSString stringWithFormat:@"http://sandbox.veespo.com/v1/info/category/%@/targets?token=%@", catId, uTk];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        block(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        block([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"]);
    }];
    
    [operation start];
}

@end
