//
//  FSConverter.m
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 2/7/13.
//
//

#import "FSConverter.h"
#import "FSVenue.h"
#import "UIImageView+AFNetworking.h"

@implementation FSConverter

- (NSArray*)convertToObjects:(NSArray*)venues
{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:venues.count];
    for (NSDictionary *v  in venues) {
        FSVenue *ann = [[FSVenue alloc]init];
        ann.name = v[@"name"];
        ann.venueId = v[@"id"];

        ann.location.address = v[@"location"][@"address"];
        ann.location.distance = v[@"location"][@"distance"];
        
        [ann.location setCoordinate:CLLocationCoordinate2DMake([v[@"location"][@"lat"] doubleValue],
                                                      [v[@"location"][@"lng"] doubleValue])];
        
        NSArray *cats = [NSArray arrayWithObject:v[@"categories"]];
        NSDictionary *dic = [[cats firstObject] firstObject];
        NSString *prefix;
        
        ann.category = dic[@"shortName"];
        
        if ( [dic[@"icon"][@"prefix"] length] > 0)
            prefix = [NSString stringWithFormat:@"%@44", dic[@"icon"][@"prefix"]];
        NSString *imageString = [NSString stringWithFormat:@"%@%@", prefix, dic[@"icon"][@"suffix"]];
        [ann setImageURL:[NSURL URLWithString:imageString]];
        
        [objects addObject:ann];
    }
    return objects;
}

@end
