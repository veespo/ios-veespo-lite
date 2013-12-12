#import "VEConnection.h"
#import "AFNetworking.h"

@implementation VEConnection

#pragma mark - Public
- (void)requestTargetList:(NSDictionary *)dataSet withBlock:(void(^)(id responseData, NSString *token))block
{
    NSString *demoCode = [dataSet objectForKey:@"democode"];
    NSString *userId = [dataSet objectForKey:@"userid"];
#warning STATIC URL
    NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/category/demo-code/%@", demoCode];
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
#warning STATIC URL
            NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/user-token/demo-code/%@?user=%@", demoCode, userId];
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

- (void)requestAverageForTarget:(NSString *)targertId withCategory:(NSString *)category withToken:(NSString *)token blockResult:(void (^)(id))block
{
    // /v1/average/category/:cat/target/:target
#warning STATIC URL
    NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/average/category/%@/target/%@?token=%@", category, targertId, token];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSDictionary *tags = [NSDictionary dictionaryWithDictionary:JSON[@"data"][@"averages"]];
                                                                                            tags = tags[@"avgS"];
                                                                                            
                                                                                            [self getTagsForCategory:category userToken:token withBlock:^(id responseData) {
                                                                                                if ([responseData isKindOfClass:[NSArray class]]) {
                                                                                                    
                                                                                                    NSMutableDictionary *newTagsList = [[NSMutableDictionary alloc] init];
                                                                                                    
                                                                                                    for (NSDictionary *dic in responseData) {
                                                                                                        [newTagsList setObject:dic[@"label"] forKey:dic[@"tag"]];
                                                                                                    }
                                                                                                
                                                                                                    NSMutableArray *list = [[NSMutableArray alloc] init];
                                                                                                    for (id key in [tags allKeys]) {
                                                                                                        NSString *label = newTagsList[key];
                                                                                                        NSString *avg = tags[key];
                                                                                                        // Ignoro tag senza media
                                                                                                        if (label && avg) {
                                                                                                            NSDictionary* object = [NSDictionary dictionaryWithObjects:@[ label, avg ] forKeys:@[ @"name", @"avg" ]];
                                                                                                            [list addObject:object];
                                                                                                        }
                                                                                                    }
                                                                                                    
                                                                                                    NSArray *sortedList = [list sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                                                        NSNumber *num1 = [NSNumber numberWithFloat:[obj1[@"avg"] floatValue]];
                                                                                                        NSNumber *num2 = [NSNumber numberWithFloat:[obj2[@"avg"] floatValue]];
                                                                                                        return (NSComparisonResult)[num1 compare:num2];
                                                                                                    }];
                                                                                                    
                                                                                                    block([[sortedList reverseObjectEnumerator] allObjects]);
                                                                                                } else {
                                                                                                    block([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"]);
                                                                                                }
                                                                                            }];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            block([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"]);
                                                                                        }];
    [operation start];
}

- (void)requestTargetsForUser:(NSString *)user withCategory:(NSString *)category withToken:(NSString *)token blockResult:(void (^)(id))block
{
#warning STATIC URL
    NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/info/category/%@/user/%@/targets?token=%@", category, user, token];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        block(JSON[@"data"]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        block([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"]);
    }];
    
    [operation start];
}

#pragma mark - Private
- (void)getTarget:(NSString *)catId userToken:(NSString *)uTk withBlock:(void(^)(id responseData))block
{
#warning STATIC URL
    NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/info/category/%@/targets?token=%@", catId, uTk];
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

- (void)getTagsForCategory:(NSString *)catId userToken:(NSString *)uTk withBlock:(void(^)(id responseData))block
{
    // /v1/info/category/:cat/tags
    // [[NSLocale preferredLanguages] objectAtIndex:0]
#warning STATIC URL
    NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/info/category/%@/tags?token=%@&lang=%@", catId, uTk, [[NSLocale preferredLanguages] objectAtIndex:0]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        block(JSON[@"data"]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        block([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"]);
    }];
    
    [operation start];
}

@end
