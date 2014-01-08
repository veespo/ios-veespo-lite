//
//  VEChartViewController.h
//  Veespo
//
//  Created by Alessio Roberto on 03/01/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JBBarChartView.h"

@interface VEChartViewController : UIViewController <JBBarChartViewDataSource, JBBarChartViewDelegate>

@property (nonatomic, strong) NSArray *avgRatesArray;
@property (nonatomic, strong) NSArray *tagNamesArray;

@end
