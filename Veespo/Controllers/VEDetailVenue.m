//
//  VEDetailVenue.m
//  Veespo
//
//  Created by Alessio Roberto on 02/10/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEDetailVenue.h"
#import "Foursquare2.h"

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
    
    self.categoryLabel.text = self.venue.category;
    self.adressLabel.text = self.venue.location.address;
    
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
#ifdef VEESPO
    VEVeespoViewController *veespoViewController = nil;
    
    NSDictionary *d = @{
                        @"local_id": self.venue.venueId, @"desc1": self.venue.name, @"desc2": self.venue.category, @"lang": @"it"
                        };
    
    veespoViewController = [[VEVeespoViewController alloc]
                            initWidgetWithToken:_token
                            targetInfo:d
                            withQuestion:[NSString stringWithFormat:@"Cosa ne pensi di %@", self.venue.name]
                            detailsView:nil
                            ];
    
    veespoViewController.closeVeespoViewController = ^(NSDictionary *data){
        NSLog(@"%@", data);
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [veespoViewController showWidget:^(NSDictionary *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messagio di debug"
                                                        message:[NSString stringWithFormat:@"Error %@", error]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
#endif
}

@end
