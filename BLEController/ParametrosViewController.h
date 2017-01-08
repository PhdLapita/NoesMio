//
//  ParametrosViewController.h
//  BLEController
//
//  Created by Avances on 29/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "BLE.h"
#import "RBLProtocol.h"

@interface ParametrosViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, SlideNavigationControllerDelegate, BLEDelegate, ProtocolDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIPickerView *pcValues;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
- (IBAction)selectValue:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viAccept;
- (IBAction)save:(id)sender;

@property (strong, nonatomic) BLE *ble;
@property (strong, nonatomic) RBLProtocol *protocol;

@end
