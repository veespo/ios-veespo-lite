@interface VEConnection : NSObject

- (void)requestTargetList:(NSDictionary *)dataSet withBlock:(void(^)(id responseData, NSString *token))block;

@end
