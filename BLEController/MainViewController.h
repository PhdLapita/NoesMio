//
//  MainViewController.h
//  BLEController
//
//  Created by Avances on 27/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "BLE.h"

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <CoreBluetooth/CoreBluetooth.h>
#else
#import <IOBluetooth/IOBluetooth.h>
#endif

@interface MainViewController : UIViewController <SlideNavigationControllerDelegate, BLEDelegate, CBCentralManagerDelegate, CBPeripheralDelegate>

//- (IBAction)goToList:(id)sender;
@property (strong, nonatomic) BLE *ble;
@property (weak, nonatomic) IBOutlet UIButton *btLink;
@property (weak, nonatomic) IBOutlet UIView *viBluetooth;
- (IBAction)openApp:(id)sender;
- (IBAction)openBluetoothSettings:(id)sender;



@end
