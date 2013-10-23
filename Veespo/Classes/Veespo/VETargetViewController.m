//
//  VETargetViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 11/10/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VETargetViewController.h"
#import <VeespoFramework/Veespo.h>
#import <VeespoFramework/VEVeespoViewController.h>

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
    NSArray *keys = [_targetList allKeys];
    for (int i = 0; i < keys.count; i++) {
        NSDictionary *dict = [_targetList objectForKey:[keys objectAtIndex:i]];
        [target addObject:[NSDictionary dictionaryWithObjectsAndKeys:[keys objectAtIndex:i], @"targetid", dict, @"desc", nil]];
    }
//    [Veespo initUser:_userid apiKey:@"" userName:nil language:@"it" veespoGroup:nil fileConfig:nil urlConfig:nil test:NO sandBox:NO];
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
    cell.textLabel.text = dict[@"desc"][@"desc1"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dict = [target objectAtIndex:indexPath.row];
//    VEVeespoViewController *veespoViewController = [[VEVeespoViewController alloc] initWithDetailsView:nil background:(SYSTEM_VERSION_LESS_THAN(@"7.0"))?nil:[self.view snapshotViewAfterScreenUpdates:NO]];
//    veespoViewController.closeVeespoViewController = ^(NSDictionary *data){
//        [self dismissViewControllerAnimated:YES completion:nil];
//    };
//    [veespoViewController setSkins:8];
//    
//    [self presentViewController:veespoViewController animated:YES completion:^{
//        [veespoViewController loadDataFor:[dict objectForKey:@"targetid"]
//                                    title:@"Cosa ne pensi?"];
//    }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
