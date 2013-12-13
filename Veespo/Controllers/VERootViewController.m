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
		self.title = title;
//		_revealBlock = [revealBlock copy];
//		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"259-list.png"] style:UIBarButtonItemStylePlain target:self action:@selector(revealSidebar)];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor whiteColor]];
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
