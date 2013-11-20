//
//  VETargetDetailViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 11/10/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VETargetDetailViewController.h"

@interface VETargetDetailViewController ()

@end

@implementation VETargetDetailViewController

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
	
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Valuta" style:UIBarButtonItemStylePlain target:self action:@selector(openVeespo)];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
#ifdef VEESPO
    [Veespo initUser:_userid apiKey:@"" userName:@"" language:@"it" veespoGroup:@"" fileConfig:@"" urlConfig:@"" test:NO sandBox:NO];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openVeespo
{
#ifdef VEESPO
    VEVeespoViewController *veespoViewController = [[VEVeespoViewController alloc] initWithDetailsView:nil background:(SYSTEM_VERSION_LESS_THAN(@"7.0"))?nil:[self.view snapshotViewAfterScreenUpdates:NO]];
    veespoViewController.closeVeespoViewController = ^(NSDictionary *data){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [veespoViewController setSkins:8];
    
    [self presentViewController:veespoViewController animated:YES completion:^{
        [veespoViewController loadDataFor:[_target objectForKey:@"targetid"]
                                    title:@"Cosa ne pensi?"];
    }];
#endif
}

@end
