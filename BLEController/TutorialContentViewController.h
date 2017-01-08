//
//  TutorialContentViewController.h
//  BLEController
//
//  Created by Avances on 26/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


@property NSUInteger pageIndex;
@property NSString *contentText;
@property NSString *titleText;
@property NSString *imageFile;

@end
