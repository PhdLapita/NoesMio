//
//  SignoVitalViewController.h
//  BLEController
//
//  Created by Avances on 29/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "BLE.h"
#import "RBLProtocol.h"

@interface SignoVitalViewController : UIViewController <SlideNavigationControllerDelegate, ProtocolDelegate, BLEDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lbMeasure;
@property (weak, nonatomic) IBOutlet UILabel *lbDay;
@property (weak, nonatomic) IBOutlet UILabel *lbMonth;
@property (weak, nonatomic) IBOutlet UIButton *btDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbDescription;
@property (weak, nonatomic) IBOutlet UIImageView *ivBackground;
@property (weak, nonatomic) IBOutlet UIImageView *ivIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;
@property int indicatorType;
@property (weak, nonatomic) IBOutlet UILabel *lbTitleDescription;


@property (strong, nonatomic) BLE *ble;
@property (strong, nonatomic) RBLProtocol *protocol;
@property BOOL switchActivated;
-(void) processData:(uint8_t *) data length:(uint8_t) length;
@property (strong, nonatomic) NSString *lastUUID;

@end
