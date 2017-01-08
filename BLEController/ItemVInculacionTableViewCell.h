//
//  ItemVInculacionTableViewCell.h
//  BLEController
//
//  Created by Avances on 27/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemVInculacionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *lbDeviceId;
@property (weak, nonatomic) IBOutlet UIImageView *ivStatus;
@property BOOL status;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;

@end
