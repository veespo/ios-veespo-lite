@interface VEConnection : NSObject

- (void)getCountRatingsForCategory:(NSString *)category
                         andTarget:(NSString *)target
                         withToken:(NSString *)token
                           success:(void(^)(id responseData))success
                           failure:(void (^)(id error))failure;

- (void)getRatingsForTarget:(NSString *)target
                andCategory:(NSString *)category
                  withToken:(NSString *)token
                    success:(void(^)(NSDictionary * responseData))success
                    failure:(void (^)(id error))failure;

- (void)getRatingTag:(NSString *)tag
           forTarget:(NSString *)target
          inCategory:(NSString *)category
           withToken:(NSString *)token
             success:(void(^)(NSDictionary * responseData))success
             failure:(void (^)(id error))failure;

@end
