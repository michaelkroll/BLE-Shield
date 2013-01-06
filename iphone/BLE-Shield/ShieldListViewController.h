//
//  ShieldListViewController.h
//  BLE-Shield
//
//  Created by Michael Kroll on 1/3/13.
//  Copyright (c) 2013 Michael Kroll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ShieldTableViewController.h"

@interface ShieldListViewController : UITableViewController {
    MBProgressHUD *HUD;
}

- (void)connectBLEShieldSuccess:(NSNotification *)notification;
- (void)connectBLEShieldFailure:(NSNotification *)notification;

- (void)showScanIndicator;
- (void)hideScanIndicator;

@end
