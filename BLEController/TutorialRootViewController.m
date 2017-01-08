//
//  TutorialRootViewController.m
//  BLEController
//
//  Created by Avances on 26/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import "TutorialRootViewController.h"
#import "MainViewController.h"
#import "RBLAppDelegate.h"

@interface TutorialRootViewController ()

@end

@implementation TutorialRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Create the data model
    _pageTitles = @[@"Conéctate", @"Descubre", @"Activar"];
    _pageDescriptions = @[@"Enlaza tu prenda con la aplicacion vía bluetooth, de esta forma podrás estar conectado con tu app.",
                          @"Visualiza los valores de todos tus signos vitales. Si requieres más información ingresa al detalle.",
                          @"Si algo anda mal con algún valor de tus signos vitales se activará de forma automática."];
    
    _pageImages = @[@"tutorial-01-app.png", @"tutorial-02-app.png", @"tutorial-03-app.png"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    TutorialContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 140);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}


- (IBAction)startWalkthrough:(id)sender {
    /*
    TutorialContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    */

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:NO andCompletion:nil];
    
    [[[RBLAppDelegate sharedAppDelegate] window] setRootViewController:[SlideNavigationController sharedInstance]];
}

- (TutorialContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    TutorialContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.contentText = self.pageDescriptions[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutorialContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    self.btStart.hidden = YES;
    self.viRootCredits.hidden = NO;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutorialContentViewController*) viewController).pageIndex;
    
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        self.btStart.hidden = NO;
        self.viRootCredits.hidden = YES;
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


- (IBAction)tapClose:(id)sender {
    [self startWalkthrough:nil];    
}
@end
