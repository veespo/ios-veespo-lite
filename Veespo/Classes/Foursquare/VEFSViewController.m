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
#import "VEVenueCell.h"
#import "UIImageView+AFNetworking.h"
#import "VEFSHeaderView.h"

@interface VEFSViewController (){
    int locationUpdateCnt;
    CLLocation *lastLocation;
}

@end

@implementation VEFSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationUpdateCnt = 0;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateVenuesCollection)];
    
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.navigationController.navigationBar.frame), 64)];
//    backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1 alpha:.8];
//    backgroundView.opaque = NO;
//    [self.navigationController.view insertSubview:backgroundView belowSubview:self.navigationController.navigationBar];
    
    // MAKMapView
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, 320, 128)];
    [mapView setShowsUserLocation:YES];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setRotateEnabled:YES];
    mapView.delegate = self;
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(0, 192, 320, 1)];
    div.backgroundColor = [UIColor lightGrayColor];
    
    // TableView
    CGRect appBounds = [UIScreen mainScreen].bounds;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // setting cell attributes globally via layout properties ///////////////
//    layout.itemSize = CGSizeMake(128, 128);
//    layout.minimumInteritemSpacing = 64;
//    layout.minimumLineSpacing = 64;
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.sectionInset = UIEdgeInsetsMake(32, 32, 32, 32);
    venuesCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, mapView.frame.origin.y + mapView.frame.size.height + 1, appBounds.size.width, appBounds.size.height - 191) collectionViewLayout:layout];
    venuesCollection.delegate = self;
    venuesCollection.dataSource = self;
    venuesCollection.backgroundColor = [UIColor whiteColor];
    [venuesCollection registerClass:[VEVenueCell class] forCellWithReuseIdentifier:@"FoursquareCell"];
    [venuesCollection registerClass:[VEFSHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FoursquareFooterView"];
    [venuesCollection reloadData];
    
    // LocationManager
	_locationManager = [[CLLocationManager alloc]init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    
    [self.view addSubview:div];
    [self.view addSubview:mapView];
    [self.view addSubview:venuesCollection];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    locationUpdateCnt = 0;
    [_locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    nearbyVenues = nil;
    locationUpdateCnt = 0;
    [_locationManager stopUpdatingLocation];
}

-(void)userDidSelectVenue{
    // TODO: Open Veespo Vidget
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
    lastLocation = newLocation;
    if (locationUpdateCnt++ < 3)
        [self getVenuesForLocation:newLocation];
    else
        _locationManager.distanceFilter = 200;
    [self setupMapForLocatoion:newLocation];
}

-(void)removeAllAnnotationExceptOfCurrentUser
{
    NSMutableArray *annForRemove = [[NSMutableArray alloc] initWithArray:mapView.annotations];
    if ([mapView.annotations.lastObject isKindOfClass:[MKUserLocation class]]) {
        [annForRemove removeObject:mapView.annotations.lastObject];
    } else {
        for (id <MKAnnotation> annot_ in mapView.annotations)
        {
            if ([annot_ isKindOfClass:[MKUserLocation class]] ) {
                [annForRemove removeObject:annot_];
                break;
            }
        }
    }
    
    [mapView removeAnnotations:annForRemove];
}

-(void)proccessAnnotations{
    [self removeAllAnnotationExceptOfCurrentUser];
    [mapView addAnnotations:nearbyVenues];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation{
    if (annotation == map.userLocation)
        return nil;
    
    static NSString *s = @"ann";
    MKAnnotationView *pin = [map dequeueReusableAnnotationViewWithIdentifier:s];
    if (!pin) {
        pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:s];
        pin.canShowCallout = YES;
        pin.image = [UIImage imageNamed:@"pin.png"];
        pin.calloutOffset = CGPointMake(0, 0);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [button addTarget:self
                   action:@selector(checkinButton) forControlEvents:UIControlEventTouchUpInside];
        pin.rightCalloutAccessoryView = button;
        
    }
    return pin;
}

-(void)checkinButton{
    selected = mapView.selectedAnnotations.lastObject;
    [self userDidSelectVenue];
}

#pragma mark - Foursquare2

- (void)updateVenuesCollection
{
    [self getVenuesForLocation:lastLocation];
}

- (void)getVenuesForLocation:(CLLocation*)location
{
    if (HUD) {
        [HUD hide:NO];
        HUD = nil;
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    [Foursquare2 searchVenuesNearByLatitude:@(location.coordinate.latitude)
								  longitude:@(location.coordinate.longitude)
								 accuracyLL:nil
								   altitude:nil
								accuracyAlt:nil
									  query:nil
									  limit:nil
									 intent:intentBrowse
                                     radius:@(700)
                                 categoryId:catCibi
								   callback:^(BOOL success, id result){
									   if (success) {
										   NSDictionary *dic = result;
										   NSArray* venues = [dic valueForKeyPath:@"response.venues"];
                                           FSConverter *converter = [[FSConverter alloc]init];
                                           nearbyVenues = [converter convertToObjects:venues];
                                           [self proccessAnnotations];
                                           [venuesCollection reloadData];
                                           [HUD hide:YES afterDelay:1.5];
									   } else
                                           [HUD hide:YES];
								   }];
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [nearbyVenues count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VEVenueCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FoursquareCell" forIndexPath:indexPath];
    cell.backgroundColor = UIColorFromRGB(0xDBDBDB);
    FSVenue *venue = nearbyVenues[indexPath.row];
    cell.venueNameLbl.text = [venue name];
    if (venue.location.address) {
        cell.venueAddressLbl.text = [NSString stringWithFormat:@"%@m, %@",
                                     venue.location.distance,
                                     venue.location.address];
    }else{
        cell.venueAddressLbl.text = [NSString stringWithFormat:@"%@m",
                                     venue.location.distance];
    }
    cell.venueCategoryLbl.text = [venue category];
    [cell.venueIcon setImageWithURL:venue.imageURL];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
     return CGSizeMake(0, 40);
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    VEFSHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                         UICollectionElementKindSectionFooter withReuseIdentifier:@"FoursquareFooterView" forIndexPath:indexPath];
    return headerView;
}

#pragma mark - UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(135, 120);
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 20, 50, 20);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self userDidSelectVenue];
}

@end
