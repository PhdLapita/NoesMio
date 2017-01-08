//
//  RegistroSignoTableViewCell.h
//  BLEController
//
//  Created by Avances on 29/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistroSignoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDescription;
@property (weak, nonatomic) IBOutlet UILabel *lbQuantity;

@end
