//
//  UIDevice(Identifier).h
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import <UIKit/UIDevice.h>


@interface UIDevice (IdentifierAddition)
/*
 * @method macAddress
 * @description iOS7 will not available
 */
- (NSString *) macAddress;
/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */
- (NSString *) uniqueGlobalDeviceIdentifier;

@end
