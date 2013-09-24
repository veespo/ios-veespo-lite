//
//  VEFSViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 24/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEFSViewController.h"
#import "Foursquare2.h"
#import "FSConverter.h"
#import "FSVenue.h"

@interface VEFSViewController ()

@end

@implementation VEFSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // MAKMapView
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 128)];
    [mapView setShowsUserLocation:YES];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setRotateEnabled:YES];
    
    // Footer
    footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:footer.frame];
    imageView.image = [UIImage imageNamed:@"poweredByFoursquare_gray.png"];
    [imageView setContentMode:UIViewContentModeCenter];
    [footer addSubview:imageView];
    
    // TableView
    CGRect appBounds = [UIScreen mainScreen].bounds;
//    venuesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, appBounds.size.width, appBounds.size.height - 64) style:UITableViewStylePlain];
//    venuesTableView.delegate = self;
//    venuesTableView.dataSource = self;
//    venuesTableView.tableHeaderView = mapView;
//    venuesTableView.tableFooterView = footer;
    
    // LocationManager
	_locationManager = [[CLLocationManager alloc]init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
//    [self.view addSubview:venuesTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location and Map

-(void)setupMapForLocatoion:(CLLocation*)newLocation{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.003;
    span.longitudeDelta = 0.003;
    CLLocationCoordinate2D location;
    location.latitude = newLocation.coordinate.latitude;
    location.longitude = newLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    [_locationManager stopUpdatingLocation];
    [self getVenuesForLocation:newLocation];
    [self setupMapForLocatoion:newLocation];
}

#pragma mark - Foursquare2

-(void)getVenuesForLocation:(CLLocation*)location{
    [Foursquare2 searchVenuesNearByLatitude:@(location.coordinate.latitude)
								  longitude:@(location.coordinate.longitude)
								 accuracyLL:nil
								   altitude:nil
								accuracyAlt:nil
									  query:nil
									  limit:nil
									 intent:intentCheckin
                                     radius:@(500)
                                 categoryId:nil
								   callback:^(BOOL success, id result){
									   if (success) {
										   NSDictionary *dic = result;
										   NSArray* venues = [dic valueForKeyPath:@"response.venues"];
                                           FSConverter *converter = [[FSConverter alloc]init];
                                           nearbyVenues = [converter convertToObjects:venues];
//                                           [venuesTableView reloadData];
//                                           [self proccessAnnotations];
                                           
									   }
								   }];
}

@end
