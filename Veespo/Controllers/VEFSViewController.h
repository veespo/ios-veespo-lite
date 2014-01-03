//
//  VEFSViewController.h
//  Veespo
//
//  Created by Alessio Roberto on 24/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VERootViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class FSVenue;

@interface VEFSViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@end
