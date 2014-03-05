#import "VEConnection.h"
#import "AFNetworking.h"

@implementation VEConnection

#pragma mark - Public

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

- (void)getRatingsForTarget:(NSString *)target
                andCategory:(NSString *)category
                  withToken:(NSString *)token
                    success:(void(^)(NSDictionary * responseData))success
                    failure:(void (^)(id error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/ratings/category/%@/target/%@?token=%@&labels=%@", category, target, token, [[NSLocale preferredLanguages] objectAtIndex:0]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *result = @{@"labels": JSON[@"data"][@"labels"], @"ratings": JSON[@"data"][@"ratings"]};
        success(result);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"]);
    }];
    
    [operation start];
}

- (void)getRatingTag:(NSString *)tag
           forTarget:(NSString *)target
          inCategory:(NSString *)category
           withToken:(NSString *)token
             success:(void(^)(NSDictionary * responseData))success
             failure:(void (^)(id error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"http://production.veespo.com/v1/ratings/category/%@/target/%@/tag/%@?token=%@&labels=%@",
                        category,
                        target,
                        tag,
                        token,
                        [[NSLocale preferredLanguages] objectAtIndex:0]
                        ];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (JSON[@"data"][@"labels"] == nil)
            success(nil);
        else {
            NSDictionary *result = @{@"labels": JSON[@"data"][@"labels"], @"ratings": JSON[@"data"][@"ratings"]};
            success(result);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"]);
    }];
    
    [operation start];
}

@end
