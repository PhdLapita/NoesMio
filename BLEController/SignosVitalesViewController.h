//
//  SignosVitalesViewController.h
//  BLEController
//
//  Created by Avances on 28/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "BLE.h"
#import "RBLProtocol.h"

@interface SignosVitalesViewController : UIViewController <SlideNavigationControllerDelegate, ProtocolDelegate, BLEDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lbRespiration;
@property (weak, nonatomic) IBOutlet UILabel *lbCardio;
@property (weak, nonatomic) IBOutlet UILabel *lbMovement;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
- (IBAction)openTemperature:(id)sender;
- (IBAction)openRespiration:(id)sender;
- (IBAction)openCardio:(id)sender;
- (IBAction)openMovement:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *ivTemperature;
@property (weak, nonatomic) IBOutlet UIImageView *ivRespiration;
@property (weak, nonatomic) IBOutlet UIImageView *ivCardio;
@property (weak, nonatomic) IBOutlet UIImageView *ivMovement;

@property (strong, nonatomic) BLE *ble;
@property (strong, nonatomic) RBLProtocol *protocol;
@property BOOL switchActivated;
-(void) processData:(uint8_t *) data length:(uint8_t) length;
@property (strong, nonatomic) NSString *lastUUID;

@property (weak, nonatomic) IBOutlet UIView *viLoading;

@end
