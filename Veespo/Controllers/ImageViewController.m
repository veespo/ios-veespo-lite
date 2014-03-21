//
//  ImageViewController.m
//  VCTransitions
//
//  Created by Tyler Tillage on 7/3/13.
//  Copyright (c) 2013 CapTech. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () {
    UIImageView *_imageView;
}

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Feedback", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(openVeespo:)
                                              ];
    
    if (self.token == nil)
        self.navigationItem.rightBarButtonItem.enabled = NO;
    
    _imageView = [[UIImageView alloc] initWithImage:self.photo];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:_imageView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_imageView]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
}
/*
- (IBAction)openVeespo:(id)sender
{
#ifdef VEESPO
    NSDictionary *d = @{
                        @"local_id": self.local_id,
                        @"desc1": self.headline,
                        @"desc2": self.newsTitle,
                        @"lang": [[NSLocale preferredLanguages] objectAtIndex:0]
                        };
    
    NSDictionary *p = @{@"question": @{
                                @"text": NSLocalizedString(@"Veespo News Question", nil),
                                @"category": @"news"
                                }
                        };
    
    VEVeespoViewController *veespoViewController = [[VEVeespoViewController alloc] initWidgetWithToken:_token targetInfo:d targetParameters:nil parameters:p detailsView:nil];
    
    veespoViewController.closeVeespoViewController = ^(NSDictionary *data){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [veespoViewController showWidget:^(NSDictionary *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil)
                                                        message:NSLocalizedString(@"Veespo Error", nil)
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
#endif
}
*/
@end
