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
                [self getTargets:catId userToken:JSON[@"data"][@"reply"] withBlock:^(id responseData) {
                    __block NSMutableDictionary *targets = [NSMutableDictionary dictionaryWithObjectsAndKeys:catId, @"category",  responseData[@"data"], @"targets", nil];
                    NSString *token = JSON[@"data"][@"reply"];
                    // Richiesta nome categoria
                    [self getCategoryInfo:catId userToken:token withBlock:^(id responseData) {
                        [targets setObject:responseData forKey:@"categoryname"];
                        block(targets, token);
                    }];
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

- (void)requestAverageForTarget:(NSString *)targertId withCategory:(NSString *)category withToken:(NSString *)token blockResult:(void (^)(id result, id overall))block
{
    // /v1/average/category/:cat/target/:target
#warning STATIC URL
    NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/average/category/%@/target/%@?token=%@&labels=%@",
                        category,
                        targertId,
                        token,
                        [[NSLocale preferredLanguages] objectAtIndex:0]
                        ];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSDictionary *avgs = [NSDictionary dictionaryWithDictionary:JSON[@"data"][@"averages"]];
                                                                                            NSString *overallStr = avgs[@"overall"];
                                                                                            NSDictionary *freqs = avgs[@"sumN"];
                                                                                            avgs = avgs[@"avgS"];
                                                                                            
                                                                                            NSDictionary *tagsLabelList = [NSDictionary dictionaryWithDictionary:JSON[@"data"][@"labels"]];
                                                                                            
                                                                                            NSMutableArray *resultList = [[NSMutableArray alloc] init];
                                                                                            
                                                                                            for (id key in [freqs allKeys]) {
                                                                                                NSString *label = tagsLabelList[key][@"label"];
                                                                                                NSString *connotation = tagsLabelList[key][@"connotation"];
                                                                                                NSString *avg = avgs[key];
                                                                                                NSString *freq = freqs[key];
                                                                                                
                                                                                                // Ignoro tag senza media
                                                                                                if (label && avg) {
                                                                                                    NSDictionary* object = [NSDictionary dictionaryWithObjects:@[ key, label, connotation, avg, freq ] forKeys:@[ @"tag", @"name", @"connotation", @"avg", @"ctr" ]];
                                                                                                    [resultList addObject:object];
                                                                                                }
                                                                                            }
                                                                                            
                                                                                            block(resultList, overallStr);
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            block([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"], nil);
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

- (void)getCategoryInfo:(NSString *)catId userToken:(NSString *)uTk withBlock:(void(^)(id responseData))block
{
#warning STATIC URL
    NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/info/category/%@?token=%@", catId, uTk];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        block(JSON[@"data"][@"desc1"]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        block([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"]);
    }];
    
    [operation start];
}

- (void)requestAvgTargetsForTag:(NSString *)tag withCategory:(NSString *)category withToken:(NSString *)token blockResult:(void(^)(id result))block
{
#warning STATIC URL
    NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/average/category/%@/tag/%@?token=%@", category, tag, token];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *data = JSON[@"data"][@"averages"];
        NSArray *targetsList = [NSArray array];
        NSMutableArray *list = [NSMutableArray array];
        
        NSArray *keys = data[@"avgS"];
        for (id key in keys) {
            [list addObject:@{@"target": key, @"avg": data[@"avgS"][key]}];
        }
        
        targetsList = [list sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *avg1 = [NSNumber numberWithFloat:[obj1[@"avg"] floatValue]];
            NSNumber *avg2 = [NSNumber numberWithFloat:[obj2[@"avg"] floatValue]];
            return [avg2 compare:avg1];
        }];
        
        block(targetsList);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        block([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"]);
    }];
    
    [operation start];
}

- (void)getCountRatingsForCategory:(NSString *)category
                         andTarget:(NSString *)target
                         withToken:(NSString *)token
                           success:(void(^)(id responseData))success
                           failure:(void (^)(id error))failure
{
    // /v1/count/ratings/category/:cat/target/:target
    NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/count/ratings/category/%@/target/%@?token=%@&lang=%@", category, target, token, [[NSLocale preferredLanguages] objectAtIndex:0]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        success(JSON[@"data"][@"count"]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"]);
    }];
    
    [operation start];
}

#pragma mark - Private

- (void)getTargets:(NSString *)catId userToken:(NSString *)uTk withBlock:(void(^)(id responseData))block
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
