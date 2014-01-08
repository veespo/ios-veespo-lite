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

- (void)requestAverageForTarget:(NSString *)targertId withCategory:(NSString *)category withToken:(NSString *)token blockResult:(void (^)(id result, id overall))block
{
    // /v1/average/category/:cat/target/:target
#warning STATIC URL
    NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/average/category/%@/target/%@?token=%@&labels=it", category, targertId, token];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSDictionary *avgs = [NSDictionary dictionaryWithDictionary:JSON[@"data"][@"averages"]];
                                                                                            NSString *overallStr = avgs[@"overall"];
                                                                                            avgs = avgs[@"avgS"];
                                                                                            
                                                                                            NSDictionary *tagsLabelList = [NSDictionary dictionaryWithDictionary:JSON[@"data"][@"labels"]];
                                                                                            
                                                                                            NSMutableArray *resultList = [[NSMutableArray alloc] init];
                                                                                            
                                                                                            for (id key in [avgs allKeys]) {
                                                                                                NSString *label = tagsLabelList[key][@"label"];
                                                                                                NSString *connotation = tagsLabelList[key][@"connotation"];
                                                                                                NSString *avg = avgs[key];
                                                                                                
                                                                                                // Ignoro tag senza media
                                                                                                if (label && avg) {
                                                                                                    NSDictionary* object = [NSDictionary dictionaryWithObjects:@[ label, connotation, avg ] forKeys:@[ @"name", @"connotation", @"avg" ]];
                                                                                                    [resultList addObject:object];
                                                                                                }
                                                                                            }
                                                                                            
                                                                                            NSArray *sortedList = [resultList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                                                NSNumber *num1 = [NSNumber numberWithFloat:[obj1[@"avg"] floatValue]];
                                                                                                NSNumber *num2 = [NSNumber numberWithFloat:[obj2[@"avg"] floatValue]];
                                                                                                return (NSComparisonResult)[num1 compare:num2];
                                                                                            }];
                                                                                            
                                                                                            block([[sortedList reverseObjectEnumerator] allObjects], overallStr);
                                                                                            
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
