//
//  VEDetailVenue.m
//  Veespo
//
//  Created by Alessio Roberto on 02/10/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEDetailVenue.h"
#import "Foursquare2.h"

#import <VeespoFramework/VEVeespoViewController.h>

@interface VEDetailVenue ()

@end

@implementation VEDetailVenue

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Valuta" style:UIBarButtonItemStylePlain target:self action:@selector(openVeespo:)];
    
    if ([_token isEqualToString:@""] || _token == nil) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [Foursquare2 getDetailForVenue:self.venue.venueId callback:^(BOOL success, id result) {
        NSLog(@"%@", result);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openVeespo:(id)sender
{
    VEVeespoViewController *veespoViewController = nil;
    
    NSDictionary *d = @{
                        @"local_id": self.venue.venueId, @"desc1": self.venue.name, @"desc2": self.venue.location.address, @"lang": @"it"
                        };
    
    veespoViewController = [[VEVeespoViewController alloc]
                            initWidgetWithToken:_token
                            targetInfo:d
                            withQuestion:[NSString stringWithFormat:@"Cosa ne pensi di %@", self.venue.name]
                            detailsView:nil
                            background:(SYSTEM_VERSION_LESS_THAN(@"7.0"))?nil:[self.view snapshotViewAfterScreenUpdates:NO]
                            ];
    
    veespoViewController.closeVeespoViewController = ^(NSDictionary *data){
        NSLog(@"%@", data);
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [veespoViewController setSkins:8];
    
    if (veespoViewController)
        [self presentViewController:veespoViewController animated:YES completion:nil];
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attenzione" message:@"Errore di login con Veespo (messagio di debug)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
