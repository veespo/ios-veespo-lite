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

@interface VEFSViewController : VERootViewController <CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
    MKMapView* mapView;
//    UITableView* venuesTableView;
    UIView *footer;
    
    FSVenue* selected;
    NSArray* nearbyVenues;
}

@end
