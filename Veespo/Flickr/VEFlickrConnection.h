//
//  VEFlickrConnection.h
//  Veespo
//
//  Created by Alessio Roberto on 05/03/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VEFlickrConnection : NSObject

/**
 *    Return list of all photos in a set
 *
 *    @param setid   The set id.
 *    @param success A block
 *    @param failure A block
 */
- (void)getPhotosInSet:(NSString *)setid
                success:(void(^)(NSArray *responseData))success
                failure:(void (^)(id error))failure;

/**
 *    Return photos url
 *
 *    @param photoid The photo id
 *    @param success A block
 *    @param failure A block
 */
- (void)getPhotoThumb:(NSString *)photoid
              success:(void (^)(NSDictionary *responseData))success
              failure:(void (^)(id error))failure;

@end
