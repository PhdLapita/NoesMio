//
//  ParametroTableViewCell.h
//  BLEController
//
//  Created by Avances on 29/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParametroTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ivShow;
@property (weak, nonatomic) IBOutlet UILabel *lbNormalSince;
@property (weak, nonatomic) IBOutlet UILabel *lbNormalUntil;
@property (weak, nonatomic) IBOutlet UILabel *lbOutSince;
@property (weak, nonatomic) IBOutlet UILabel *lbOutUntil;
@property (weak, nonatomic) IBOutlet UIView *viContainer;
@property (weak, nonatomic) IBOutlet UIView *viShow;
@property (weak, nonatomic) IBOutlet UIView *viNormalSince;
@property (weak, nonatomic) IBOutlet UIView *viNormalUntil;
@property (weak, nonatomic) IBOutlet UIView *viOutSince;
@property (weak, nonatomic) IBOutlet UIView *viOutUntil;

@end
