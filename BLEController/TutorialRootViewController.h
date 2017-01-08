//
//  TutorialRootViewController.h
//  BLEController
//
//  Created by Avances on 26/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutorialContentViewController.h"
#import "SlideNavigationController.h"

@interface TutorialRootViewController : UIViewController <UIPageViewControllerDataSource>
- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageDescriptions;
@property (strong, nonatomic) NSArray *pageImages;
@property (weak, nonatomic) IBOutlet UIButton *btStart;
@property (weak, nonatomic) IBOutlet UIView *viRootCredits;

- (IBAction)tapClose:(id)sender;
@end
