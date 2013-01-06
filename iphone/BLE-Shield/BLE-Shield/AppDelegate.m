//
//  AppDelegate.m
//  BLE-Shield
//
//  Created by Michael Kroll on 11/10/12.
//  Copyright (c) 2012 Michael Kroll. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize cbManager;
@synthesize shields;
@synthesize connectedShield;

@synthesize window;
@synthesize navigationController;
@synthesize shieldListViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.shieldListViewController = [[ShieldListViewController alloc] initWithStyle:UITableViewStylePlain];
    self.shieldListViewController.title = NSLocalizedString(@"BLE-Shield", @"");
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.shieldListViewController];
    self.navigationController.navigationBar.tintColor = [UIColor bluetoothBlue];
    self.navigationController.toolbar.tintColor = [UIColor bluetoothBlue];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    
    self.cbManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.shields = [NSMutableArray arrayWithCapacity:10];
    
    BtLog(@"startScan");
    NSArray	*uuidArray = [NSArray arrayWithObject:[CBUUID UUIDWithString:kBLEShieldServiceUUIDString]];
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [self.cbManager scanForPeripheralsWithServices:uuidArray options:options];

    // register notification handlers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationScanForBLEShields) name:NOTIFICATION_START_SCAN_FOR_BLE_SHIELDS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationStopScanForBLEShields) name:NOTIFICATION_STOP_SCAN_FOR_BLE_SHIELDS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationConnectBLEShield:) name:NOTIFICATION_CONNECT_BLE_SHIELD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDisconnectBLEShield:) name:NOTIFICATION_DISCONNECT_BLE_SHIELD object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationWriteBLEShieldBuffer:) name:NOTIFICATION_WRITE_BLE_SHIELD_BUFFER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReadBLEShieldBuffer:) name:NOTIFICATION_READ_BLE_SHIELD_BUFFER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReadBLEShieldBufferSize:) name:NOTIFICATION_READ_BLE_SHIELD_BUFFER_SIZE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationClearBLEShieldBufferSize:) name:NOTIFICATION_CLEAR_BLE_SHIELD_BUFFER_SIZE object:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // register notification handlers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_START_SCAN_FOR_BLE_SHIELDS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_STOP_SCAN_FOR_BLE_SHIELDS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CONNECT_BLE_SHIELD object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_DISCONNECT_BLE_SHIELD object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_WRITE_BLE_SHIELD_BUFFER object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_READ_BLE_SHIELD_BUFFER object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_READ_BLE_SHIELD_BUFFER_SIZE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CLEAR_BLE_SHIELD_BUFFER_SIZE object:nil];
}

#pragma mark -
#pragma mark CBCentralManagerDelegate methods

/*
 *  @method centralManagerDidUpdateState:
 *
 *  @param central The central whose state has changed.
 *
 *  @discussion Invoked whenever the central's state has been updated.
 *      See the "state" property for more information.
 *
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOff) {
        BtLog(@"");
    }
    else if (central.state == CBCentralManagerStatePoweredOn) {
        BtLog(@"");
    }
}


/*
 *  @method centralManager:didRetrievePeripheral:
 *
 *  @discussion Invoked when the central retrieved a list of known peripherals.
 *      See the -[retrievePeripherals:] method for more information.
 *
 */
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    BtLog(@"");
}

/*
 *  @method centralManager:didRetrieveConnectedPeripherals:
 *
 *  @discussion Invoked when the central retrieved the list of peripherals currently connected to the system.
 *      See the -[retrieveConnectedPeripherals] method for more information.
 *
 */
- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripheralArray {
    BtLog(@"");
}

/*
 *  @method centralManager:didDiscoverPeripheral:advertisementData:RSSI:
 *
 *  @discussion Invoked when the central discovered a peripheral while scanning.
 *      The advertisement / scan response data is stored in "advertisementData", and
 *      can be accessed through the CBAdvertisementData* keys.
 *      The peripheral must be retained if any command is to be performed on it.
 *
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    BtLog(@"Discovered: %@", peripheral.name);
    
    if ([self.shields count] == 0) {
        [self.shields addObject:peripheral];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.shields count] -1 inSection:0];
        [self.shieldListViewController.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:YES];
    }
    else {
        for (int i = 0; i < [self.shields count]; i++) {
            CBPeripheral *per = [self.shields objectAtIndex:i];
            if (![per.name isEqualToString:peripheral.name]) {
                [self.shields addObject:peripheral];
                NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.shields count] -1 inSection:0];
                [self.shieldListViewController.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:YES];
            }
        }
    }
}

/*
 *  @method centralManager:didConnectPeripheral:
 *
 *  @discussion Invoked whenever a connection has been succesfully created with the peripheral.
 *
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    BtLog(@"");
    
    self.connectedShield = peripheral;
    self.connectedShield.delegate = self;    
    [self.connectedShield discoverServices:nil];
}

/*
 *  @method centralManager:didFailToConnectPeripheral:error:
 *
 *  @discussion Invoked whenever a connection has failed to be created with the peripheral.
 *      The failure reason is stored in "error".
 *
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    BtLog(@"");
   [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CONNECT_BLE_SHIELD_FAILURE object:peripheral];
}

/*
 *  @method centralManager:didDisconnectPeripheral:error:
 *
 *  @discussion Invoked whenever an existing connection with the peripheral has been teared down.
 *
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    BtLog(@"");
    if (error != nil) {
        NSArray *disconnectFailureArray = [NSArray arrayWithObjects:error, peripheral, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DISCONNECT_BLE_SHIELD_FAILURE object:disconnectFailureArray];
        
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Disconnect Error", @"") message:error.localizedDescription delegate:self cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles: nil];
         [alert show];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DISCONNECT_BLE_SHIELD_SUCCESS object:peripheral];
        
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Disconnected", @"") message:peripheral.name delegate:self cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles: nil];
         [alert show];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_START_SCAN_FOR_BLE_SHIELDS object:nil];
}

/*
 *  @method peripheralDidUpdateName:
 *
 *  @param peripheral	The peripheral providing this update.
 *
 *  @discussion			This method is invoked when the @link name @/link of <i>peripheral</i> changes.
 */
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
    BtLog(@"");
}

/*
 *  @method peripheralDidInvalidateServices:
 *
 *  @param peripheral	The peripheral providing this update.
 *
 *  @discussion			This method is invoked when the @link services @/link of <i>peripheral</i> have been changed. At this point,
 *						all existing <code>CBService</code> objects are invalidated. Services can be re-discovered via @link discoverServices: @/link.
 */
- (void)peripheralDidInvalidateServices:(CBPeripheral *)peripheral {
    BtLog(@"");
}

/*
 *  @method peripheralDidUpdateRSSI:error:
 *
 *  @param peripheral	The peripheral providing this update.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link readRSSI: @/link call.
 */
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {
    BtLog(@"");
}

/*
 *  @method peripheral:didDiscoverServices:
 *
 *  @param peripheral	The peripheral providing this information.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverServices: @/link call. If the service(s) were read successfully, they can be retrieved via
 *						<i>peripheral</i>'s @link services @/link property.
 *
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    BtLog(@"");
    
    
    for (CBService *service in peripheral.services ) {
        
        CBUUID *serviceUUID = [CBUUID UUIDWithString:kBLEShieldServiceUUIDString];
        
        if ([service.UUID isEqual:serviceUUID]) {
            BtLog(@"Discovering Characteristics...");
            [self.connectedShield discoverCharacteristics:nil forService:service];
        }
    }
}

/*
 *  @method peripheral:didDiscoverIncludedServicesForService:error:
 *
 *  @param peripheral	The peripheral providing this information.
 *  @param service		The <code>CBService</code> object containing the included services.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverIncludedServices:forService: @/link call. If the included service(s) were read successfully,
 *						they can be retrieved via <i>service</i>'s <code>includedServices</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error {
    BtLog(@"");
}

/*
 *  @method peripheral:didDiscoverCharacteristicsForService:error:
 *
 *  @param peripheral	The peripheral providing this information.
 *  @param service		The <code>CBService</code> object containing the characteristic(s).
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverCharacteristics:forService: @/link call. If the characteristic(s) were read successfully,
 *						they can be retrieved via <i>service</i>'s <code>characteristics</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    BtLog(@"");
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CONNECT_BLE_SHIELD_SUCCESS object:self.connectedShield];
    BtLog(@"enable notifications...");
    [BLEUtility setNotificationForCharacteristic:self.connectedShield sUUID:kBLEShieldServiceUUIDString cUUID:kBLEShieldCharacteristicRXUUIDString enable:YES];
}

/*
 *  @method peripheral:didUpdateValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method is invoked after a @link readValueForCharacteristic: @/link call, or upon receipt of a notification/indication.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    BtLog(@"");

    BLEShieldDataPacket *dataPacket = [[BLEShieldDataPacket alloc] init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    NSData *data = [characteristic value];
    
    dataPacket.fromShield = YES;
    dataPacket.characteristicUUID = characteristic.UUID;
    dataPacket.data = data;
    dataPacket.formattedDate = dateString;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BLE_SHIELD_CHARACTERISTIC_VALUE_READ object:dataPacket];
}

/*
 *  @method peripheral:didWriteValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link writeValue:forCharacteristic: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    BtLog(@"");
}

/*
 *  @method peripheral:didUpdateNotificationStateForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link setNotifyValue:forCharacteristic: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    BtLog(@"");
}

/*
 *  @method peripheral:didDiscoverDescriptorsForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link discoverDescriptorsForCharacteristic: @/link call. If the descriptors were read successfully,
 *							they can be retrieved via <i>characteristic</i>'s <code>descriptors</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    BtLog(@"");
}

/*
 *  @method peripheral:didUpdateValueForDescriptor:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param descriptor		A <code>CBDescriptor</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link readValueForDescriptor: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    BtLog(@"");
}

/*
 *  @method peripheral:didWriteValueForDescriptor:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param descriptor		A <code>CBDescriptor</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link writeValue:forDescriptor: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    BtLog(@"");
}

- (void)notificationScanForBLEShields{
    BtLog(@"");
    self.shields = [NSMutableArray arrayWithCapacity:10];
    [self.shieldListViewController.tableView reloadData];
    
    BtLog(@"startScan");
    NSArray	*uuidArray = [NSArray arrayWithObject:[CBUUID UUIDWithString:kBLEShieldServiceUUIDString]];
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [self.cbManager scanForPeripheralsWithServices:uuidArray options:options];
}

- (void)notificationStopScanForBLEShields {
    BtLog(@"");
    [self.cbManager stopScan];
    
}

- (void)notificationConnectBLEShield:(NSNotification*)notification {
    BtLog(@"");
    self.connectedShield = notification.object;
    
    BtLog(@"ConnectedShield: %@", self.connectedShield);
    
    [self.cbManager connectPeripheral:self.connectedShield options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}

- (void)notificationDisconnectBLEShield:(NSNotification*)notification {
    BtLog(@"");
    CBPeripheral *shield = notification.object;
    [self.cbManager cancelPeripheralConnection:shield];
}

- (void)notificationWriteBLEShieldBuffer:(NSNotification *)notification {
    BtLog(@"");

    BLEShieldDataPacket *dataPacket = [[BLEShieldDataPacket alloc] init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
    NSString *rawDataString = [self getRawHexString:notification.object];
    
    dataPacket.fromShield = NO;
    dataPacket.stringData = [NSString stringWithFormat:@"Write TX-Buffer: %@", rawDataString];
    dataPacket.formattedDate = dateString;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BLE_SHIELD_CHARACTERISTIC_VALUE_WRITTEN object:dataPacket];
    
    [BLEUtility writeCharacteristic:self.connectedShield sUUID:kBLEShieldServiceUUIDString cUUID:kBLEShieldCharacteristicTXUUIDString data:notification.object];
    
}

- (void)notificationReadBLEShieldBuffer:(NSNotification*)notification {
    BtLog(@"");
    
    BLEShieldDataPacket *dataPacket = [[BLEShieldDataPacket alloc] init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
    dataPacket.fromShield = NO;
    dataPacket.stringData = @"Read RX-Buffer";
    dataPacket.formattedDate = dateString;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BLE_SHIELD_CHARACTERISTIC_VALUE_READ object:dataPacket];
    
    [BLEUtility readCharacteristic:self.connectedShield sUUID:kBLEShieldServiceUUIDString cUUID:kBLEShieldCharacteristicRXUUIDString];
}

- (void)notificationReadBLEShieldBufferSize:(NSNotification*)notification {
    BtLog(@"");
    
    BLEShieldDataPacket *dataPacket = [[BLEShieldDataPacket alloc] init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
    dataPacket.fromShield = NO;
    dataPacket.stringData = @"Read RX-Buffer Size";
    dataPacket.formattedDate = dateString;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BLE_SHIELD_CHARACTERISTIC_VALUE_READ object:dataPacket];
    
    [BLEUtility readCharacteristic:self.connectedShield sUUID:kBLEShieldServiceUUIDString cUUID:kBLEShieldCharacteristicReceiveBufferUUIDString];
}

- (void)notificationClearBLEShieldBufferSize:(NSNotification*)notification {
    BtLog(@"");

    BLEShieldDataPacket *dataPacket = [[BLEShieldDataPacket alloc] init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
    dataPacket.fromShield = NO;
    dataPacket.stringData = @"Clear RX-Buffer";
    dataPacket.formattedDate = dateString;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BLE_SHIELD_CHARACTERISTIC_VALUE_READ object:dataPacket];
    
    [BLEUtility readCharacteristic:self.connectedShield sUUID:kBLEShieldServiceUUIDString cUUID:kBLEShieldCharacteristicClearReceiveBufferUUIDString];
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

@end