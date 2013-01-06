//
//  ShieldTableViewController.m
//  BLE-Shield
//
//  Created by Michael Kroll on 1/3/13.
//  Copyright (c) 2013 Michael Kroll. All rights reserved.
//

#import "ShieldTableViewController.h"

@implementation ShieldTableViewController

@synthesize connectedShield;
@synthesize dataPackets;

@synthesize sendDataButton;
@synthesize readDataButton;
@synthesize readBufferSizeButton;
@synthesize clearBufferButton;

- (id)initWithStyle:(UITableViewStyle)style andShield:(CBPeripheral*)shield {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = [UIColor darkGrayColor];
        
        self.connectedShield = shield;
        [self.navigationItem setHidesBackButton:YES animated:NO];
        self.navigationItem.title = self.connectedShield.name;
        
        self.dataPackets = [NSMutableArray arrayWithCapacity:10];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        BtLog(@"%@", self.connectedShield);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Disconnect" style:UIBarButtonItemStylePlain target:self action:@selector(disconnect)];
    self.navigationItem.leftBarButtonItem = anotherButton;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    self.sendDataButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(sendData)];
    self.readDataButton = [[UIBarButtonItem alloc] initWithTitle:@"Read" style:UIBarButtonItemStyleBordered target:self action:@selector(readData)];
    
    self.readBufferSizeButton = [[UIBarButtonItem alloc] initWithTitle:@"Buffer Size" style:UIBarButtonItemStyleBordered target:self action:@selector(readBufferSize)];
    self.clearBufferButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear Buffer" style:UIBarButtonItemStyleBordered target:self action:@selector(clearBuffer)];
    
    NSArray *items = [NSArray arrayWithObjects:self.sendDataButton, self.readDataButton, self.readBufferSizeButton, self.clearBufferButton, flexiableItem, nil];
    self.toolbarItems = items;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectSuccess:) name:NOTIFICATION_DISCONNECT_BLE_SHIELD_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectFailure:) name:NOTIFICATION_DISCONNECT_BLE_SHIELD_FAILURE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationBLEShieldCharacteristicValueRead:) name:NOTIFICATION_BLE_SHIELD_CHARACTERISTIC_VALUE_READ object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationBLEShieldCharacteristicValueWritten:) name:NOTIFICATION_BLE_SHIELD_CHARACTERISTIC_VALUE_WRITTEN object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_DISCONNECT_BLE_SHIELD_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_DISCONNECT_BLE_SHIELD_FAILURE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_BLE_SHIELD_CHARACTERISTIC_VALUE_READ object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_BLE_SHIELD_CHARACTERISTIC_VALUE_WRITTEN object:nil];
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
    return [self.dataPackets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"messagingCell";
    
    PTSMessagingCell * cell = (PTSMessagingCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[PTSMessagingCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
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
}

- (void)disconnect {
    BtLog(@"");
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = NSLocalizedString(@"Disconnecting", @"");
    
    HUD.detailsLabelText = self.connectedShield.name;
    [HUD show:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DISCONNECT_BLE_SHIELD object:self.connectedShield];
}

- (void)disconnectSuccess:(NSNotification*)notification {
    BtLog(@"");
    [HUD hide:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)disconnectFailure:(NSNotification*)notification {
    BtLog(@"");
    [HUD hide:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)notificationBLEShieldCharacteristicValueRead:(NSNotification*)notification {
    BtLog(@"");
    BLEShieldDataPacket *dataPacket = notification.object;
    [self.dataPackets addObject:dataPacket];
    [self.tableView reloadData];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.dataPackets count]-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)notificationBLEShieldCharacteristicValueWritten:(NSNotification*)notification {
    BLEShieldDataPacket *dataPacket = notification.object;
    [self.dataPackets addObject:dataPacket];
    [self.tableView reloadData];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.dataPackets count]-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLEShieldDataPacket *dp = [self.dataPackets objectAtIndex:indexPath.row];

    NSString *characteristicString = @"";    
    
    if ([dp.characteristicUUID isEqual:[CBUUID UUIDWithString:kBLEShieldCharacteristicRXUUIDString]]) {
        characteristicString = @"RX-Buffer";
    }
    else if ([dp.characteristicUUID isEqual:[CBUUID UUIDWithString:kBLEShieldCharacteristicClearReceiveBufferUUIDString]]) {
        characteristicString = @"Clear RX-Buffer";
    }
    else if ([dp.characteristicUUID isEqual:[CBUUID UUIDWithString:kBLEShieldCharacteristicReceiveBufferUUIDString]]) {
        characteristicString = @"RX-Buffer Size";
    }
    
    NSString *dataAsString = [NSString stringWithFormat:@"%@ %@", characteristicString, [self getRawHexString:dp.data]];   
    CGSize messageSize = [PTSMessagingCell messageSize:dataAsString];
    return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 60.0f;
}

-(void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath {
    PTSMessagingCell* ccell = (PTSMessagingCell*)cell;
    
    BLEShieldDataPacket *dp = [self.dataPackets objectAtIndex:indexPath.row];
    
    if (!dp.fromShield) {
        ccell.sent = YES;
        ccell.avatarImageView.image = [UIImage imageNamed:@"iphone"];
        ccell.messageLabel.text = dp.stringData;
    } else {
        ccell.sent = NO;
        ccell.avatarImageView.image = [UIImage imageNamed:@"ble-shield"];
        NSString *characteristicString = @"";
        
        if ([dp.characteristicUUID isEqual:[CBUUID UUIDWithString:kBLEShieldCharacteristicRXUUIDString]]) {
            characteristicString = @"RX-Buffer";
        }
        else if ([dp.characteristicUUID isEqual:[CBUUID UUIDWithString:kBLEShieldCharacteristicClearReceiveBufferUUIDString]]) {
            characteristicString = @"Clear RX-Buffer";
        }
        else if ([dp.characteristicUUID isEqual:[CBUUID UUIDWithString:kBLEShieldCharacteristicReceiveBufferUUIDString]]) {
            characteristicString = @"RX-Buffer Size";
        }

        NSString *dataAsString = [NSString stringWithFormat:@"%@ %@", characteristicString, [self getRawHexString:dp.data]];
        ccell.messageLabel.text = dataAsString;
    }

    ccell.timeLabel.text = dp.formattedDate;
}

- (void)sendData {
    BtLog(@"");
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Send to BLE-Shield", @"")
                                                     message:@"Send data to the TX characteristic" delegate:self cancelButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString(@"Raw", @""), NSLocalizedString(@"String", @""),  nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = ALERT_WRITE_HEX_TAG;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    //alertTextField.placeholder = [self getRawHexString];
    alertTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [alert show];
}

- (void)readData {
    BtLog(@"");
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_READ_BLE_SHIELD_BUFFER object:self.connectedShield];
}

- (void)readBufferSize {
    BtLog(@"");
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_READ_BLE_SHIELD_BUFFER_SIZE object:self.connectedShield];
}

- (void)clearBuffer {
    BtLog(@"");    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CLEAR_BLE_SHIELD_BUFFER_SIZE object:self.connectedShield];
}

- (NSString *)getRawHexString:(NSData*)rawData {
    NSMutableString *cData = [NSMutableString stringWithCapacity:([rawData length] * 2)];
    const unsigned char *dataBuffer = [rawData bytes];
    int i;
    for (i = 0; i < [rawData length]; ++i) {
        [cData appendFormat:@"%02lX", (unsigned long)dataBuffer[i]];
    }
    return [NSString stringWithFormat:@"0x%@", [cData uppercaseString]];
}

- (NSData*)dataWithHexString:(NSString *)hexString {
    
	// Hex Lookup Table
	unsigned char HEX_LOOKUP[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5,
		6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 10, 11, 12, 13, 14, 15, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 10, 11, 12, 13, 14, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	
	// If we have an odd number of characters, add an extra digit, rounding the
	// size of the NSData up to the nearest byte
	if ([hexString length] % 2 == 1)  {
		hexString = [NSString stringWithFormat:@"0%@", hexString];
	}
	
	// Iterate through the string, adding each character (equivilent to 1/2
	// byte) to the NSData result
	int i;
	char current;
	const int size = [hexString length] / 2;
	const char * stringBuffer = [hexString cStringUsingEncoding:NSASCIIStringEncoding];
	NSMutableData * result = [NSMutableData dataWithLength:size];
	char * resultBuffer = [result mutableBytes];
	for (i = 0; i < size; i++) {
		// Get first character, use as high order bits
		current = stringBuffer[i * 2];
		resultBuffer[i] = HEX_LOOKUP[current] << 4;
		
		// Get second character, use as low order bits
		current = stringBuffer[(i * 2) + 1];
		resultBuffer[i] = resultBuffer[i] | HEX_LOOKUP[current];
	}
	
    NSData *resultData = [NSData dataWithData:result];
 	return resultData;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {    

    UITextField *alertTextField = [alertView textFieldAtIndex:0];
    BtLog(@"New Value = %@", alertTextField.text);

    NSData *theNewData;
        
    if (buttonIndex == 0) {
        // send raw
        theNewData = [self dataWithHexString:alertTextField.text];
    }
    else if (buttonIndex == 1) {
        // send string
        theNewData = [alertTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WRITE_BLE_SHIELD_BUFFER object:theNewData];
}

@end