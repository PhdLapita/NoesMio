//
//  AyudaViewController.h
//  BLEController
//
//  Created by Avances on 4/11/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface AyudaViewController : UIViewController <SlideNavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ivCF;
@property (weak, nonatomic) IBOutlet UIImageView *ivPQS;
@property (weak, nonatomic) IBOutlet UIImageView *ivAP;
@property (weak, nonatomic) IBOutlet UILabel *lbCF;
@property (weak, nonatomic) IBOutlet UILabel *lbPQS;
@property (weak, nonatomic) IBOutlet UILabel *lbAP;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcHeightCF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcHeightPQS;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcHeightAP;
@property (weak, nonatomic) IBOutlet UIView *viCCF;
@property (weak, nonatomic) IBOutlet UIView *viCPQS;
@property (weak, nonatomic) IBOutlet UIView *viCAP;
@property (weak, nonatomic) IBOutlet UIImageView *ivMain;


- (IBAction)tapHowItWorks:(UITapGestureRecognizer *)sender;
- (IBAction)tapWhatIsItFor:(UITapGestureRecognizer *)sender;
- (IBAction)tapActivate:(UITapGestureRecognizer *)sender;

@end
