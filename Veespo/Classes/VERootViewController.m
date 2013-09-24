//
//  VERootViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 21/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VERootViewController.h"

@interface VERootViewController ()

@end

@implementation VERootViewController

- (id)initWithTitle:(NSString *)title withRevealBlock:(RevealBlock)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.navigationController.navigationBar.frame), 64)];
        backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1 alpha:.8];
        backgroundView.opaque = NO;
        [self.navigationController.view insertSubview:backgroundView belowSubview:self.navigationController.navigationBar];
		self.title = title;
		_revealBlock = [revealBlock copy];
		self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                      target:self
                                                      action:@selector(revealSidebar)];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor greenColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)revealSidebar {
	_revealBlock();
}

@end
