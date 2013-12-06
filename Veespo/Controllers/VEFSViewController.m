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
#import "VEDetailVenue.h"
#import "VERatedVenuesViewController.h"


static NSString * const catCibi = @"4d4b7105d754a06374d81259";
static NSString * const catLocaliNotturni = @"4d4b7105d754a06376d81259";
static int const maxLocationUpdate = 3;

@interface VEFSViewController () {
    UICollectionView *venuesCollection;
    MBProgressHUD *HUD;
    
    FSVenue* selected;
    NSMutableArray* nearbyVenues;
    
    CLLocation *lastLocation;
    
    int locationUpdateCnt;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;

@end

@implementation VEFSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationUpdateCnt = 0;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x1D7800);
    }
    
    UIBarButtonItem *venuesRatedButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"star.png"]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(openVenuesRatedView)
                                          ];
    
    UIBarButtonItem *updateVenuesButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                       target:self
                                                                                       action:@selector(updateVenuesCollection)
                                          ];
    
    NSArray *tempArray= [[NSArray alloc] initWithObjects:updateVenuesButton, venuesRatedButton, nil];
    self.navigationItem.rightBarButtonItems=tempArray;
    
    [self.locationManager startUpdatingLocation];
    [self.view addSubview:self.mapView];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(0, self.mapView.frame.origin.y + self.mapView.frame.size.height, 320, 1)];
    div.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:div];
    
    // CollectionView
    CGRect appBounds = [UIScreen mainScreen].bounds;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    venuesCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.mapView.frame.origin.y + self.mapView.frame.size.height + 1, appBounds.size.width, appBounds.size.height - 191) collectionViewLayout:layout];
    venuesCollection.delegate = self;
    venuesCollection.dataSource = self;
    venuesCollection.backgroundColor = (SYSTEM_VERSION_LESS_THAN(@"7.0"))?UIColorFromRGB(0x1D7800):[UIColor whiteColor];
    [venuesCollection registerClass:[VEVenueCell class] forCellWithReuseIdentifier:@"FoursquareCell"];
    [venuesCollection registerClass:[VEFSHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FoursquareFooterView"];
    [venuesCollection reloadData];
    
    [self.view addSubview:venuesCollection];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    locationUpdateCnt = 0;
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    nearbyVenues = nil;
    locationUpdateCnt = 0;
    [self.locationManager stopUpdatingLocation];
}

#pragma mark Properties

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (MKMapView *)mapView
{
    if (!_mapView) {
        CGFloat mapViewHeight = ([UIScreen mainScreen].bounds.size.height == 568.0f) ? 168 : 128;
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, (SYSTEM_VERSION_LESS_THAN(@"7.0"))?0:64, 320, mapViewHeight)];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            _mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_mapView setShowsUserLocation:YES];
        _mapView.delegate = self;
    }
    return _mapView;
}

#pragma mark Methods

- (void)updateVenuesCollection
{
    locationUpdateCnt = 0;
    self.locationManager.distanceFilter = 0;
    [self setupMapForLocation:lastLocation];
    [self getVenuesForLocation:lastLocation];
}

- (void)checkinButton
{
    VEAppDelegate *appDelegate = (VEAppDelegate *)[[UIApplication sharedApplication] delegate];
    selected = self.mapView.selectedAnnotations.lastObject;
    VEDetailVenue *detail = [[VEDetailVenue alloc] initWithNibName:@"VEDetailVenue" bundle:nil];
    detail.venue = selected;
    if ([detail.venue.categoryId isEqualToString:catCibi]) {
        detail.token = [appDelegate.tokens objectForKey:@"cibi"];
    } else {
        detail.token = [appDelegate.tokens objectForKey:@"localinotturni"];
    }
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)userDidSelectVenue:(NSIndexPath *)indexPath
{
    VEAppDelegate *appDelegate = (VEAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    VEDetailVenue *detail = [[VEDetailVenue alloc] initWithNibName:@"VEDetailVenue" bundle:nil];
    detail.venue = [nearbyVenues objectAtIndex:indexPath.row];

    if ([detail.venue.categoryId isEqualToString:catCibi]) {
        detail.token = [appDelegate.tokens objectForKey:@"cibi"];
    } else {
        detail.token = [appDelegate.tokens objectForKey:@"localinotturni"];
    }
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)openVenuesRatedView
{
    VERatedVenuesViewController *ratedViewController = [[VERatedVenuesViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:ratedViewController animated:YES];
}

#pragma mark - Location and Map

- (void)setupMapForLocation:(CLLocation*)newLocation
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.003;
    span.longitudeDelta = 0.003;
    CLLocationCoordinate2D location;
    location.latitude = newLocation.coordinate.latitude;
    location.longitude = newLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    lastLocation = newLocation;
    
    if (locationUpdateCnt == maxLocationUpdate) {
        locationUpdateCnt++;
        [self getVenuesForLocation:lastLocation];
        self.locationManager.distanceFilter = 50;
    } else if (locationUpdateCnt < maxLocationUpdate)
        locationUpdateCnt++;
    [self setupMapForLocation:lastLocation];
}

-(void)removeAllAnnotationExceptOfCurrentUser
{
    NSMutableArray *annForRemove = [[NSMutableArray alloc] initWithArray:self.mapView.annotations];
    if ([self.mapView.annotations.lastObject isKindOfClass:[MKUserLocation class]]) {
        [annForRemove removeObject:self.mapView.annotations.lastObject];
    } else {
        for (id <MKAnnotation> annot_ in self.mapView.annotations)
        {
            if ([annot_ isKindOfClass:[MKUserLocation class]] ) {
                [annForRemove removeObject:annot_];
                break;
            }
        }
    }
    
    [self.mapView removeAnnotations:annForRemove];
}

- (void)proccessAnnotations
{
    [self removeAllAnnotationExceptOfCurrentUser];
    [self.mapView addAnnotations:nearbyVenues];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
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



#pragma mark - Foursquare2

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
                                     radius:@(500)
                                 categoryId:catCibi
								   callback:^(BOOL success, id result){
									   if (success) {
										   NSArray* venues = [result valueForKeyPath:@"response.venues"];
                                           FSConverter *converter = [[FSConverter alloc] init];
                                           if (nearbyVenues) {
                                               [nearbyVenues removeAllObjects];
                                               nearbyVenues = nil;
                                           }
                                           nearbyVenues = (NSMutableArray *)[converter convertToObjects:venues withCategory:catCibi];
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
    static NSString *CellIdentifier = @"FoursquareCell";
    VEVenueCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
        cell = [[VEVenueCell alloc] init];
    
    cell.backgroundColor = UIColorFromRGB(0xDBDBDB);
    FSVenue *venue = nearbyVenues[indexPath.row];
    cell.venueNameLbl.text = [venue name];
    if (venue.location.address) {
        cell.venueAddressLbl.text = [NSString stringWithFormat:@"%@m, %@",
                                     venue.location.distance,
                                     venue.location.address];
    } else {
        cell.venueAddressLbl.text = [NSString stringWithFormat:@"%@m",
                                     venue.location.distance];
    }
    cell.venueCategoryLbl.text = [venue category];
    [cell.venueIcon setImageWithURL:venue.imageURL];
    [cell layoutSubviews];
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
    [self userDidSelectVenue:indexPath];
}

@end
