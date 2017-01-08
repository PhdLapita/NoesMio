//
//  ParametroViewController.h
//  BLEController
//
//  Created by Avances on 3/11/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface ParametroViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, SlideNavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIPickerView *pcValues;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (weak, nonatomic) IBOutlet UIView *viAccept;

- (IBAction)selectValue:(id)sender;
- (IBAction)save:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lbTempSince;
@property (weak, nonatomic) IBOutlet UILabel *lbTempUntil;
@property (weak, nonatomic) IBOutlet UILabel *lbRespSince;
@property (weak, nonatomic) IBOutlet UILabel *lbRespUntil;
@property (weak, nonatomic) IBOutlet UILabel *lbCardSince;
@property (weak, nonatomic) IBOutlet UILabel *lbCardUntil;
@property (weak, nonatomic) IBOutlet UILabel *lbMovSince;
@property (weak, nonatomic) IBOutlet UILabel *lbMovUntil;

@property (weak, nonatomic) IBOutlet UIView *viCTemp;
@property (weak, nonatomic) IBOutlet UIView *viCResp;
@property (weak, nonatomic) IBOutlet UIView *viCCard;
@property (weak, nonatomic) IBOutlet UIView *viCMov;
- (IBAction)tapTemp:(UITapGestureRecognizer *)sender;
- (IBAction)tapResp:(UITapGestureRecognizer *)sender;
- (IBAction)tapCard:(UITapGestureRecognizer *)sender;
- (IBAction)tapMov:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcHeightTemp;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcHeightResp;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcHeightCard;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcHeightMov;

- (IBAction)pickTempSince:(UITapGestureRecognizer *)sender;
- (IBAction)pickTempUntil:(UITapGestureRecognizer *)sender;
- (IBAction)pickRespSince:(UITapGestureRecognizer *)sender;
- (IBAction)pickRespUntil:(UITapGestureRecognizer *)sender;
- (IBAction)pickCardSince:(UITapGestureRecognizer *)sender;
- (IBAction)pickCardUntil:(UITapGestureRecognizer *)sender;
- (IBAction)pickMovSince:(UITapGestureRecognizer *)sender;
- (IBAction)pickMovUntil:(UITapGestureRecognizer *)sender;




@end
