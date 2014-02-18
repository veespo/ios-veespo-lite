//
//  VEDataChart.h
//  Veespo
//
//  Created by Alessio Roberto on 09/01/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VEDataChart : NSObject

- (NSArray *)extractNegativeTagsAvg:(NSArray *)list;
- (NSArray *)extractPositiveAndNeutralTagsAvg:(NSArray *)list;

- (NSArray *)averangeTagsOrder:(NSArray *)list balanced:(BOOL)balanced;
- (NSArray *)frequencyTagsOrder:(NSArray *)list balanced:(BOOL)balanced;

@end
