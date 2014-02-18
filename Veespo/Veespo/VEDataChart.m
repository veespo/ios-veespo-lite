//
//  VEDataChart.m
//  Veespo
//
//  Created by Alessio Roberto on 09/01/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import "VEDataChart.h"

static NSString * const negativeString = @"NEGATIVE";
static NSString * const averangeString = @"avg";
static NSString * const frequencyString = @"ctr";
static int const minTotTagsChart = 6;
static int const minTagsChart = 3;

@implementation VEDataChart

#pragma mark - Public Methods
- (NSArray *)averangeTagsOrder:(NSArray *)list balanced:(BOOL)balanced
{
    NSArray *newList = [self extractNegativeTagsAvg:list];
    
    if (balanced && list.count < minTotTagsChart) {
        NSArray *other = [self extractPositiveAndNeutralTagsAvg:list];
        newList = [self checkTagsBalance:newList otherTags:other];
        return [newList arrayByAddingObjectsFromArray:other];
    } else
        return [newList arrayByAddingObjectsFromArray:[self extractPositiveAndNeutralTagsAvg:list]];
}

- (NSArray *)frequencyTagsOrder:(NSArray *)list balanced:(BOOL)balanced
{
    return [self reorderListDecreasing:list forValue:frequencyString];
}

- (NSArray *)extractNegativeTagsAvg:(NSArray *)list
{
    NSArray *newList = [self extractNegativeTags:list];
    
    return [self reorderListDecreasing:newList forValue:averangeString];
}

- (NSArray *)extractPositiveAndNeutralTagsAvg:(NSArray *)list
{
    NSArray *newList = [self extractPositiveAndNeutralTags:list];
    
    return [self reorderListIncreasing:newList forValue:averangeString];
}

#pragma mark - Private Methods
- (NSArray *)checkTagsBalance:(NSArray *)negativeList otherTags:(NSArray *)otherList
{
    NSMutableArray *emptyTags = [NSMutableArray array];
    
    int dif = minTotTagsChart - negativeList.count - otherList.count;
    
    NSDictionary *tag = @{@"name": @"", @"connotation": @"", @"avg": @""};
    for (int i = 0; i < dif; i++) {
        [emptyTags addObject:tag];
    }
    
    return [negativeList arrayByAddingObjectsFromArray:emptyTags];
}

#pragma mark Tag Connotation
- (NSArray *)extractNegativeTags:(NSArray *)list
{
    NSMutableArray *negativeTags = [NSMutableArray array];
    for(NSDictionary *obj in list) {
        if ([[obj objectForKey:@"connotation"] isEqualToString:negativeString])
            [negativeTags addObject:obj];
    }
    return (NSArray *)negativeTags;
}

- (NSArray *)extractPositiveAndNeutralTags:(NSArray *)list
{
    NSMutableArray *otherTags = [NSMutableArray array];
    for(NSDictionary *obj in list) {
        if (![[obj objectForKey:@"connotation"] isEqualToString:negativeString])
            [otherTags addObject:obj];
    }
    return (NSArray *)otherTags;
}
#pragma mark Tag Value Order
- (NSArray *)reorderListDecreasing:(NSArray *)list forValue:(NSString *)value
{
    NSArray *sortedList = [list sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *num1 = [NSNumber numberWithFloat:[obj1[value] floatValue]];
        NSNumber *num2 = [NSNumber numberWithFloat:[obj2[value] floatValue]];
        return (NSComparisonResult)[num1 compare:num2];
    }];
    
    return [[sortedList reverseObjectEnumerator] allObjects];
}

- (NSArray *)reorderListIncreasing:(NSArray *)list forValue:(NSString *)value
{
    NSArray *sortedList = [list sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *num1 = [NSNumber numberWithFloat:[obj1[value] floatValue]];
        NSNumber *num2 = [NSNumber numberWithFloat:[obj2[value] floatValue]];
        return (NSComparisonResult)[num1 compare:num2];
    }];
    
    return [[sortedList objectEnumerator] allObjects];
}

@end
