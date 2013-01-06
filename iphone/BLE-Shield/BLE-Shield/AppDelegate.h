//
//  AppDelegate.h
//  BLE-Shield
//
//  Created by Michael Kroll on 11/10/12.
//  Copyright (c) 2012 Michael Kroll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ShieldListViewController.h"
#import "BLEUtility.h"
#import "BLEShieldDataPacket.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *cbManager;
@property (strong, nonatomic) NSMutableArray *shields;
@property (strong, nonatomic) CBPeripheral *connectedShield;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) ShieldListViewController *shieldListViewController;

- (void)notificationScanForBLEShields;
- (void)notificationStopScanForBLEShields;
- (void)notificationConnectBLEShield:(NSNotification*)notification;
- (void)notificationDisconnectBLEShield:(NSNotification*)notification;

- (void)notificationWriteBLEShieldBuffer:(NSNotification*)notification;
- (void)notificationReadBLEShieldBuffer:(NSNotification*)notification;
- (void)notificationReadBLEShieldBufferSize:(NSNotification*)notification;
- (void)notificationClearBLEShieldBufferSize:(NSNotification*)notification;

- (NSString *)getRawHexString:(NSData*)rawData;

@end
