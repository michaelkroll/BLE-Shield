//
//  BLEShieldDataPacket.h
//  BLE-Shield
//
//  Created by Michael Kroll on 1/5/13.
//  Copyright (c) 2013 Michael Kroll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEShieldDataPacket : NSObject

@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSString *stringData;
@property (strong, nonatomic) NSString *formattedDate;
@property (strong, nonatomic) CBUUID *characteristicUUID;
@property (nonatomic, readwrite) BOOL fromShield;


@end
