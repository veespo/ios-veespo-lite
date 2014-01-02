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
        [objects addObject:[self converterToObject:v]];
    }
    return objects;
}

- (NSArray*)convertToObjects:(NSArray*)venues withCategory:(NSString *)cat
{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:venues.count];
    for (NSDictionary *v in venues) {
        FSVenue *ann = [[FSVenue alloc]init];
        ann.name = v[@"name"];
        ann.venueId = v[@"id"];
        [ann setCategoryId:[cat copy]];
        
        ann.location.address = v[@"location"][@"address"];
        ann.location.distance = v[@"location"][@"distance"];
        
        [ann.location setCoordinate:CLLocationCoordinate2DMake([v[@"location"][@"lat"] doubleValue],
                                                               [v[@"location"][@"lng"] doubleValue])];
        
        NSArray *cats = [NSArray arrayWithObject:v[@"categories"]];
        NSDictionary *dic = [[cats firstObject] firstObject];
        NSString *prefix;
        
        ann.category = dic[@"shortName"];
        
        if ( [dic[@"icon"][@"prefix"] length] > 0)
            prefix = [NSString stringWithFormat:@"%@bg_44", dic[@"icon"][@"prefix"]];
        NSString *imageString = [NSString stringWithFormat:@"%@%@", prefix, dic[@"icon"][@"suffix"]];
        [ann setImageURL:[NSURL URLWithString:imageString]];
        
        ann.categoryImage = [UIImage imageNamed:@"default_bg_44"];
        
        [objects addObject:ann];
    }
    return objects;
}

- (FSVenue *)converterToObject:(NSDictionary *)venue
{
    FSVenue *ann = [[FSVenue alloc]init];
    ann.name = venue[@"name"];
    ann.venueId = venue[@"id"];
    
    ann.location.address = venue[@"location"][@"address"];
    ann.location.distance = venue[@"location"][@"distance"];
    
    [ann.location setCoordinate:CLLocationCoordinate2DMake([venue[@"location"][@"lat"] doubleValue],
                                                           [venue[@"location"][@"lng"] doubleValue])];
    
    NSArray *cats = [NSArray arrayWithObject:venue[@"categories"]];
    NSDictionary *dic = [[cats firstObject] firstObject];
    NSString *prefix;
    
    ann.category = dic[@"shortName"];
    
    if ( [dic[@"icon"][@"prefix"] length] > 0)
        prefix = [NSString stringWithFormat:@"%@bg_44", dic[@"icon"][@"prefix"]];
    NSString *imageString = [NSString stringWithFormat:@"%@%@", prefix, dic[@"icon"][@"suffix"]];
    [ann setImageURL:[NSURL URLWithString:imageString]];
    
    ann.categoryImage = [UIImage imageNamed:@"default_bg_44"];
    
    return ann;
}

@end
