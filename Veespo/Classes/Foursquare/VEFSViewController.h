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

@interface VEFSViewController : VERootViewController <MKMapViewDelegate, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    CLLocationManager *_locationManager;
    MKMapView* mapView;
    UICollectionView *venuesCollection;
    UIView *footer;
    
    FSVenue* selected;
    NSArray* nearbyVenues;
}

@end
