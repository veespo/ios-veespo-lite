//
//  VEFlickrConnection.m
//  Veespo
//
//  Created by Alessio Roberto on 05/03/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import "VEFlickrConnection.h"
#import "AFNetworking.h"

static NSString * const kVEFlickrApiKey     = @"Flickr Key";
static NSString * const kVEFlickrApiSecret  = @"Flickr secret";

@implementation VEFlickrConnection

// Get list photos in a set http://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=d35af515af4b9d496fb6fbf9a11c517c&photoset_id=72157634258095601&format=json&nojsoncallback=1

// Get photo size http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=d35af515af4b9d496fb6fbf9a11c517c&photo_id=12417978764&format=json&nojsoncallback=1

- (void)getPhotosInSet:(NSString *)setid success:(void (^)(NSArray *))success failure:(void (^)(id))failure
{
    NSString *keysPath = [[NSBundle mainBundle] pathForResource:kVEKeysFileName ofType:@"plist"];
    if (!keysPath) {
        NSLog(@"To use API make sure you have a Veespo-Keys.plist with the Identifier in your project");
        return;
    }
    
    NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:keysPath];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=%@&photoset_id=72157634258095601&format=json&nojsoncallback=1", keys[kVEFlickrApiKey]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        success(JSON[@"photoset"][@"photo"]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"]);
    }];
    
    [operation start];
}

- (void)getPhotoThumb:(NSString *)photoid success:(void (^)(NSDictionary *))success failure:(void (^)(id))failure
{
    NSString *keysPath = [[NSBundle mainBundle] pathForResource:kVEKeysFileName ofType:@"plist"];
    if (!keysPath) {
        NSLog(@"To use API make sure you have a Veespo-Keys.plist with the Identifier in your project");
        return;
    }
    
    NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:keysPath];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", keys[kVEFlickrApiKey], photoid];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *list = JSON[@"sizes"][@"size"];
        success(@{@"size": @[[list objectAtIndex:4], [list objectAtIndex:8]]});
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure([NSDictionary dictionaryWithObject:NSLocalizedString(@"Network error", nil) forKey:@"error"]);
    }];
    
    [operation start];
}

@end
