//
//  ListadoVinculacionViewController.h
//  BLEController
//
//  Created by Avances on 4/11/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "BLE.h"
#import "RBLProtocol.h"

@protocol RBLDetailViewControllerDelegate <NSObject>

- (void) didSelected:(NSInteger)selected;

@end

@interface ListadoVinculacionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SlideNavigationControllerDelegate, BLEDelegate, UIAlertViewDelegate>
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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiLoad;
@property (weak, nonatomic) IBOutlet UILabel *lbDetectDevice;


@end
