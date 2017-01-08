//
//  VibracionViewController.h
//  BLEController
//
//  Created by Avances on 30/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"
#import "RBLProtocol.h"
#import "SlideNavigationController.h"

@interface VibracionViewController : UIViewController <SlideNavigationControllerDelegate, ProtocolDelegate, BLEDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
- (IBAction)activate:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *ivCloth;

@property (strong, nonatomic) BLE *ble;
@property (strong, nonatomic) RBLProtocol *protocol;
@property BOOL switchActivated;
-(void) processData:(uint8_t *) data length:(uint8_t) length;

@end
