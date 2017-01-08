//
//  ListadoVinculacionTableViewController.h
//  BLEController
//
//  Created by Avances on 27/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "BLE.h"

@protocol RBLDetailViewControllerDelegate <NSObject>

- (void) didSelected:(NSInteger)selected;

@end

@interface ListadoVinculacionTableViewController : UITableViewController <SlideNavigationControllerDelegate, BLEDelegate, UIAlertViewDelegate>
{
    BOOL showAlert;
    bool isFindingLast;
}

@property (strong, nonatomic) BLE *ble;


@property (strong, nonatomic) NSMutableArray *mDevices;
@property (strong, nonatomic) NSMutableArray *mDevicesName;
@property (strong, nonatomic) NSMutableArray *BLEDevices;
@property (strong, nonatomic) NSString *lastUUID;
@property (strong, nonatomic) NSMutableArray *BLEDevicesRssi;
@property (strong, nonatomic) NSMutableArray *BLEDevicesName;

@end
