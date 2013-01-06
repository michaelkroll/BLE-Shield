//
//  ShieldTableViewController.h
//  BLE-Shield
//
//  Created by Michael Kroll on 1/3/13.
//  Copyright (c) 2013 Michael Kroll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PTSMessagingCell.h"

@interface ShieldTableViewController : UITableViewController <UIAlertViewDelegate> {
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) CBPeripheral *connectedShield;
@property (strong, nonatomic) NSMutableArray *dataPackets;

@property (strong, nonatomic) UIBarButtonItem *sendDataButton;
@property (strong, nonatomic) UIBarButtonItem *readDataButton;
@property (strong, nonatomic) UIBarButtonItem *readBufferSizeButton;
@property (strong, nonatomic) UIBarButtonItem *clearBufferButton;

- (id)initWithStyle:(UITableViewStyle)style andShield:(CBPeripheral*)shield;
- (void)disconnect;
- (void)disconnectSuccess:(NSNotification*)notification;
- (void)disconnectFailure:(NSNotification*)notification;

- (void)sendData;
- (void)readData;
- (void)readBufferSize;
- (void)clearBuffer;

- (void)notificationBLEShieldCharacteristicValueRead:(NSNotification*)notification;
- (void)notificationBLEShieldCharacteristicValueWritten:(NSNotification*)notification;

- (NSString *)getRawHexString:(NSData*)rawData;
- (NSData*)dataWithHexString:(NSString *)hexString;

@end
