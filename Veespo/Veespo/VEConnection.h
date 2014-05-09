@interface VEConnection : NSObject

- (void)veespoCodeTargetsList:(NSString *)veespoCode
                 userIdentify:(NSString *)userid
                      success:(void(^)(id responseData))success
                      failure:(void (^)(id error))failure;

@end
