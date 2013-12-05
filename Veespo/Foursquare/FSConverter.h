//
//  FSConverter.h
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 2/7/13.
//
//

#import <Foundation/Foundation.h>

@class FSVenue;

@interface FSConverter : NSObject

- (NSArray*)convertToObjects:(NSArray*)venues;
- (NSArray*)convertToObjects:(NSArray*)venues withCategory:(NSString *)cat;
- (FSVenue *)converterToObject:(NSDictionary *)venue;

@end
