//
//  RBLSwitchViewController.h
//  BLEController
//
//  Created by Avances on 21/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBLProtocol.h"
#import "BLE.h"

@interface RBLSwitchViewController : UIViewController <ProtocolDelegate>

@property (strong, nonatomic) BLE *ble;
@property (strong, nonatomic) RBLProtocol *protocol;

-(void) processData:(uint8_t *) data length:(uint8_t) length;

@property BOOL switchActivated;
- (IBAction)switchVibration:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lblEstado;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiLoad;

@end
