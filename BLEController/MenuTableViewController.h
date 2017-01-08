//
//  MenuTableViewController.h
//  BLEController
//
//  Created by Avances on 27/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "BLE.h"


@interface MenuTableViewController : UITableViewController

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) BLE *ble;

@end
