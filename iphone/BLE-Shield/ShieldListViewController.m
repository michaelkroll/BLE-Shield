//
//  ShieldListViewController.m
//  BLE-Shield
//
//  Created by Michael Kroll on 1/3/13.
//  Copyright (c) 2013 Michael Kroll. All rights reserved.
//

#import "ShieldListViewController.h"

@implementation ShieldListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [self showScanIndicator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectBLEShieldSuccess:) name:NOTIFICATION_CONNECT_BLE_SHIELD_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectBLEShieldFailure:) name:NOTIFICATION_CONNECT_BLE_SHIELD_FAILURE object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CONNECT_BLE_SHIELD_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CONNECT_BLE_SHIELD_FAILURE object:nil];
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
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return [appDelegate.shields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    cell.textLabel.text = ((CBPeripheral*)[appDelegate.shields objectAtIndex:indexPath.row]).name;
    cell.imageView.image = [UIImage imageNamed:@"ble-shield-list"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    [self hideScanIndicator];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STOP_SCAN_FOR_BLE_SHIELDS object:self];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = NSLocalizedString(@"Connecting...", @"");
    
    CBPeripheral *shield = [appDelegate.shields objectAtIndex:indexPath.row];
    [HUD show:YES];
    
    // try to connect to periperal
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CONNECT_BLE_SHIELD object:shield];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)connectBLEShieldSuccess:(NSNotification *)notification {
    BtLog(@"");
    [HUD hide:YES];
    ShieldTableViewController *svc = [[ShieldTableViewController alloc] initWithStyle:UITableViewStylePlain andShield:notification.object];
    [self.navigationController pushViewController:svc  animated:YES];
}

- (void)connectBLEShieldFailure:(NSNotification *)notification {
    BtLog(@"");
    [HUD hide:YES];
}

- (void)showScanIndicator {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

- (void)hideScanIndicator {
    self.navigationItem.rightBarButtonItem = nil;
}

@end
