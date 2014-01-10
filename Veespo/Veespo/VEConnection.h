@interface VEConnection : NSObject

- (void)requestTargetList:(NSDictionary *)dataSet withBlock:(void(^)(id responseData, NSString *token))block;

- (void)requestAverageForTarget:(NSString *)targertId withCategory:(NSString *)category withToken:(NSString *)token blockResult:(void(^)(id result, id overall))block;

- (void)requestTargetsForUser:(NSString *)user withCategory:(NSString *)category withToken:(NSString *)token blockResult:(void(^)(id result))block;

- (void)getCategoryInfo:(NSString *)catId userToken:(NSString *)uTk withBlock:(void(^)(id responseData))block;

@end
