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
#import "MBProgressHUD.h"

static NSString * const catCibi = @"4d4b7105d754a06374d81259";
static NSString * const catLocaliNotturni = @"4d4b7105d754a06376d81259";
static int const maxLocationUpdate = 1;

@interface VEFSViewController () {
    UITableView *venuesTableView;
    
    FSVenue* selected;
    NSMutableArray* nearbyVenues;
    
    CLLocation *lastLocation;
    
    int locationUpdateCnt;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation VEFSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Venues", nil);
    
    locationUpdateCnt = 0;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.navigationController.navigationBar.tintColor = UIColorFromHex(0x221E1F);
    } else {
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = UIColorFromHex(0x221E1F);
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor]};
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    UIBarButtonItem *venuesRatedButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"price_tag.png"]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(openVenuesRatedView)
                                          ];
    
    self.navigationItem.rightBarButtonItem = venuesRatedButton;
    
    [self.view addSubview:self.mapView];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(0, self.mapView.frame.origin.y + self.mapView.frame.size.height, 320, 1)];
    div.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:div];
    
    // UITableView
    CGRect appBounds = [UIScreen mainScreen].bounds;
    venuesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mapView.frame.origin.y + self.mapView.frame.size.height + 1, appBounds.size.width, appBounds.size.height - 191) style:UITableViewStylePlain];
    venuesTableView.delegate = self;
    venuesTableView.dataSource = self;
    venuesTableView.backgroundColor = [UIColor whiteColor];
    [venuesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = venuesTableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl .attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Pull", nil)];
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(42, 5, 236, 30)];
    imageView.image = [UIImage imageNamed:@"poweredByFoursquare_gray.png"];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    [imageView setContentMode:UIViewContentModeCenter];
    [footerView addSubview:imageView];
    
    venuesTableView.tableFooterView = footerView;
    
    [self.view addSubview:venuesTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.locationManager startUpdatingLocation];
    
    VEAppDelegate *appDelegate = (VEAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.tokens == nil)
        self.navigationItem.rightBarButtonItem.enabled = NO;
    else
        self.navigationItem.rightBarButtonItem.enabled = YES;
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, mapViewHeight)];
        [_mapView setShowsUserLocation:YES];
        _mapView.delegate = self;
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
            _mapView.tintColor = UIColorFromHex(0x1D7800);
    }
    return _mapView;
}

#pragma mark Methods

- (void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Refresh", nil)];
    [self updateVenuesCollection];
    [refresh endRefreshing];
}

- (void)updateVenuesCollection
{
    // Force start up limit
    locationUpdateCnt = maxLocationUpdate;
    lastLocation = nil;
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
//    self.locationManager.distanceFilter = 50;
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
    
    // First time waitin maxLocationUpdate before call getVenuesForLocation
    // to improve user's position
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
        pin.image = [UIImage imageNamed:@"marker"];
        pin.calloutOffset = CGPointMake(0, 0);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [button addTarget:self
                   action:@selector(checkinButton) forControlEvents:UIControlEventTouchUpInside];
        pin.rightCalloutAccessoryView = button;
        
    }
    return pin;
}



#pragma mark - Foursquare2

- (void)getVenuesForLocation:(CLLocation*)location
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [Foursquare2 searchVenuesNearByLatitude:@(location.coordinate.latitude)
								  longitude:@(location.coordinate.longitude)
								 accuracyLL:nil
								   altitude:nil
								accuracyAlt:nil
									  query:nil
									  limit:nil
									 intent:intentBrowse
                                     radius:@(800)
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
                                           [venuesTableView reloadData];
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
									   } else
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
								   }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (nearbyVenues) ? nearbyVenues.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColorFromHex(0xFFFFFF) : UIColorFromHex(0xF1F1F2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FoursquareCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    FSVenue *venue = nearbyVenues[indexPath.row];
    
    cell.textLabel.text = [venue name];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Black" size:17];
    
    if (venue.location.address) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                     venue.location.address];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m",
                                     venue.location.distance];
    }
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Light" size:12];
    
    [cell.imageView setImageWithURL:venue.imageURL placeholderImage:venue.categoryImage];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self userDidSelectVenue:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
