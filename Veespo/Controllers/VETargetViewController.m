//
//  VETargetViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 11/10/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VETargetViewController.h"

@interface VETargetViewController () {
    NSMutableArray *target;
}

@end

@implementation VETargetViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    target = [[NSMutableArray alloc] init];
    
    for (NSDictionary *tar in _targetList) {
       [target addObject:tar];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return target.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [target objectAtIndex:indexPath.row];
    cell.textLabel.text = dict[@"desc1"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef VEESPO
    [Veespo initVeespo:@"demo" userId:@"demo" partnerId:@"demo" language:[[NSLocale preferredLanguages] objectAtIndex:0] categories:nil testUrl:YES tokens:^(id responseData, BOOL error) {
        ;
    }];
    
    NSDictionary *dict = [target objectAtIndex:indexPath.row];
    VEVeespoViewController *veespoViewController = [[VEVeespoViewController alloc] initWidgetWithToken:self.token
                                                                                                target:dict[@"target"]
                                                                                          withQuestion:[NSString stringWithFormat:@"Cosa ne pensi di %@?", dict[@"desc1"]]
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
