//
//  ParametroViewController.m
//  BLEController
//
//  Created by Avances on 3/11/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import "ParametroViewController.h"
#import "RBLAppDelegate.h"
#import "MainViewController.h"

static NSDictionary *VALUES_TEMPERATURE;
static NSDictionary *VALUES_RESPIRATION;
static NSDictionary *VALUES_CARDIO;
static NSDictionary *VALUES_MOVEMENT;

int const TEMPERATURE = 0;
int const RESPIRATION = 1;
int const CARDIO = 2;
int const MOVEMENT = 3;

float const zero = 0.f;
float const normalHeight = 68.f;

@interface ParametroViewController ()

@property (nonatomic,strong) NSMutableArray *RANGE_TEMPERATURE;
@property (nonatomic,strong) NSMutableArray *RANGE_RESPIRATION;
@property (nonatomic,strong) NSMutableArray *RANGE_CARDIO;
@property (nonatomic,strong) NSMutableArray *RANGE_MOVEMENT;
@property (nonatomic,strong) NSMutableArray *currentRange;

@property int currentValueChange;
@property int currentValue;

@property float tValNormalSince;
@property float tValNormalUntil;

@property float rValNormalSince;
@property float rValNormalUntil;

@property float cValNormalSince;
@property float cValNormalUntil;

@property float mValNormalSince;
@property float mValNormalUntil;

@end

@implementation ParametroViewController

@synthesize RANGE_TEMPERATURE;
@synthesize RANGE_RESPIRATION;
@synthesize RANGE_CARDIO;
@synthesize RANGE_MOVEMENT;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VALUES_TEMPERATURE = @{@"normal":@[@36.5,@37.2], @"out":@[@37.3,@39]};
    VALUES_RESPIRATION = @{@"normal":@[@12,@16], @"out":@[@17,@25]};
    VALUES_CARDIO = @{@"normal":@[@60,@100], @"out":@[@101,@200]};
    VALUES_MOVEMENT = @{@"normal":@[@50,@70], @"out":@[@80,@100]};
    
    RANGE_TEMPERATURE = [NSMutableArray new];
    RANGE_RESPIRATION = [NSMutableArray new];
    RANGE_CARDIO = [NSMutableArray new];
    RANGE_MOVEMENT = [NSMutableArray new];
    self.currentRange = [NSMutableArray new];
    
    for (float i = 35.0; i <= 42; i = i + 0.1) {
        i = ceilf(i * 10)/10;
        [RANGE_TEMPERATURE addObject:[NSNumber numberWithFloat:i]];
    }
    for (int i = 1; i <= 30; i++) {
        [RANGE_RESPIRATION addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 40; i <= 200; i++) {
        [RANGE_CARDIO addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 10; i <= 100; i++) {
        [RANGE_MOVEMENT addObject:[NSNumber numberWithInt:i]];
    }
    
    
    RBLAppDelegate *appDelegate = [RBLAppDelegate sharedAppDelegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Parameters" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count > 0) {
        for (NSManagedObject *info in fetchedObjects) {
            self.tValNormalSince = [(NSNumber *)[info valueForKey:@"tNormalSince"] floatValue];
            self.tValNormalUntil = [(NSNumber *)[info valueForKey:@"tNormalUntil"] floatValue];
            self.rValNormalSince = [(NSNumber *)[info valueForKey:@"rNormalSince"] floatValue];
            self.rValNormalUntil = [(NSNumber *)[info valueForKey:@"rNormalUntil"] floatValue];
            self.cValNormalSince = [(NSNumber *)[info valueForKey:@"cNormalSince"] floatValue];
            self.cValNormalUntil = [(NSNumber *)[info valueForKey:@"cNormalUntil"] floatValue];
            self.mValNormalSince = [(NSNumber *)[info valueForKey:@"mNormalSince"] floatValue];
            self.mValNormalUntil = [(NSNumber *)[info valueForKey:@"mNormalUntil"] floatValue];
        }
    }
    else{
        
        self.tValNormalSince = [(NSNumber *)[VALUES_TEMPERATURE objectForKey:@"normal"][0] floatValue];
        self.tValNormalUntil = [(NSNumber *)[VALUES_TEMPERATURE objectForKey:@"normal"][1] floatValue];
        self.rValNormalSince = [(NSNumber *)[VALUES_RESPIRATION objectForKey:@"normal"][0] floatValue];
        self.rValNormalUntil = [(NSNumber *)[VALUES_RESPIRATION objectForKey:@"normal"][1] floatValue];
        self.cValNormalSince = [(NSNumber *)[VALUES_CARDIO objectForKey:@"normal"][0] floatValue];
        self.cValNormalUntil = [(NSNumber *)[VALUES_CARDIO objectForKey:@"normal"][1] floatValue];
        self.mValNormalSince = [(NSNumber *)[VALUES_MOVEMENT objectForKey:@"normal"][0] floatValue];
        self.mValNormalUntil = [(NSNumber *)[VALUES_MOVEMENT objectForKey:@"normal"][1] floatValue];
    }
    
    self.lbTempSince.text = [NSString stringWithFormat:@"%.1f", self.tValNormalSince];
    self.lbTempUntil.text = [NSString stringWithFormat:@"%.1f", self.tValNormalUntil];
    self.lbRespSince.text = [NSString stringWithFormat:@"%.0f", self.rValNormalSince];
    self.lbRespUntil.text = [NSString stringWithFormat:@"%.0f", self.rValNormalUntil];
    self.lbCardSince.text = [NSString stringWithFormat:@"%.0f", self.cValNormalSince];
    self.lbCardUntil.text = [NSString stringWithFormat:@"%.0f", self.cValNormalUntil];
    self.lbMovSince.text = [NSString stringWithFormat:@"%.0f", self.mValNormalSince];
    self.lbMovUntil.text = [NSString stringWithFormat:@"%.0f", self.mValNormalUntil];
    
    
    self.currentValueChange = 0;
    self.currentValue = -1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)tapTemp:(UITapGestureRecognizer *)sender {
    NSLog(@"tapTemp");
    NSLog(@"%f", self.lcHeightTemp.constant);
    
    [UIView animateWithDuration:2.0 animations:^{
        
        //self.lcHeightTemp.constant = (self.lcHeightTemp.constant != 0) ? zero : normalHeight;
        
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)tapResp:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:2.0 animations:^{
        
        //self.lcHeightResp.constant = (self.lcHeightResp.constant != 0) ? zero : normalHeight;
        
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)tapCard:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:2.0 animations:^{
        
        //self.lcHeightCard.constant = (self.lcHeightCard.constant != 0) ? zero : normalHeight;
        
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)tapMov:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:2.0 animations:^{
        
        //self.lcHeightMov.constant = (self.lcHeightMov.constant != 0) ? zero : normalHeight;
        
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)pickTempSince:(UITapGestureRecognizer *)sender {
    float max = [self.lbTempUntil.text floatValue];
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < RANGE_TEMPERATURE.count; i++) {
        if ([RANGE_TEMPERATURE[i] floatValue] < max) {
            [arr addObject:RANGE_TEMPERATURE[i]];
        }
        if ([RANGE_TEMPERATURE[i] floatValue] == [self.lbTempSince.text floatValue]) {
            self.currentValue = i;
        }
    }
    self.currentRange = arr;
    self.currentValueChange = 1;
    [self displayPicker];
}

- (IBAction)pickTempUntil:(UITapGestureRecognizer *)sender {
    float min = [self.lbTempSince.text floatValue];
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < RANGE_TEMPERATURE.count; i++) {
        if ([RANGE_TEMPERATURE[i] floatValue] > min) {
            [arr addObject:RANGE_TEMPERATURE[i]];
        }
    }
    self.currentRange = arr;
    for (int i = 0; i < self.currentRange.count; i++) {
        if ([self.currentRange[i] floatValue] == [self.lbTempUntil.text floatValue]) {
            self.currentValue = i;
        }
    }
    self.currentValueChange = 2;
    [self displayPicker];
    
}

- (IBAction)pickRespSince:(UITapGestureRecognizer *)sender {
    float max = [self.lbRespUntil.text floatValue];
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < RANGE_RESPIRATION.count; i++) {
        if ([RANGE_RESPIRATION[i] floatValue] < max) {
            [arr addObject:RANGE_RESPIRATION[i]];
        }
        if ([RANGE_RESPIRATION[i] floatValue] == [self.lbRespSince.text floatValue]) {
            self.currentValue = i;
        }
    }
    
    self.currentRange = arr;
    self.currentValueChange = 3;
    [self displayPicker];
}

- (IBAction)pickRespUntil:(UITapGestureRecognizer *)sender {
    float min = [self.lbRespSince.text floatValue];
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < RANGE_RESPIRATION.count; i++) {
        if ([RANGE_RESPIRATION[i] floatValue] > min) {
            [arr addObject:RANGE_RESPIRATION[i]];
        }
    }
    self.currentRange = arr;
    for (int i = 0; i < self.currentRange.count; i++) {
        if ([self.currentRange[i] floatValue] == [self.lbRespUntil.text floatValue]) {
            self.currentValue = i;
        }
    }
    self.currentValueChange = 4;
    [self displayPicker];
}

- (IBAction)pickCardSince:(UITapGestureRecognizer *)sender {
    float max = [self.lbCardUntil.text floatValue];
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < RANGE_CARDIO.count; i++) {
        if ([RANGE_CARDIO[i] floatValue] < max) {
            [arr addObject:RANGE_CARDIO[i]];
        }
        if ([RANGE_CARDIO[i] floatValue] == [self.lbCardSince.text floatValue]) {
            self.currentValue = i;
        }
    }
    
    self.currentRange = arr;
    self.currentValueChange = 5;
    [self displayPicker];
}

- (IBAction)pickCardUntil:(UITapGestureRecognizer *)sender {
    float min = [self.lbCardSince.text floatValue];
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < RANGE_CARDIO.count; i++) {
        if ([RANGE_CARDIO[i] floatValue] > min) {
            [arr addObject:RANGE_CARDIO[i]];
        }
    }
    self.currentRange = arr;
    for (int i = 0; i < self.currentRange.count; i++) {
        if ([self.currentRange[i] floatValue] == [self.lbCardUntil.text floatValue]) {
            self.currentValue = i;
        }
    }
    self.currentValueChange = 6;
    [self displayPicker];
}

- (IBAction)pickMovSince:(UITapGestureRecognizer *)sender {
    float max = [self.lbMovUntil.text floatValue];
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < RANGE_MOVEMENT.count; i++) {
        if ([RANGE_MOVEMENT[i] floatValue] < max) {
            [arr addObject:RANGE_MOVEMENT[i]];
        }
        if ([RANGE_MOVEMENT[i] floatValue] == [self.lbMovSince.text floatValue]) {
            self.currentValue = i;
        }
    }
    
    self.currentRange = arr;
    self.currentValueChange = 7;
    [self displayPicker];
}

- (IBAction)pickMovUntil:(UITapGestureRecognizer *)sender {
    float min = [self.lbMovSince.text floatValue];
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < RANGE_MOVEMENT.count; i++) {
        if ([RANGE_MOVEMENT[i] floatValue] > min) {
            [arr addObject:RANGE_MOVEMENT[i]];
        }
    }
    self.currentRange = arr;
    for (int i = 0; i < self.currentRange.count; i++) {
        if ([self.currentRange[i] floatValue] == [self.lbMovUntil.text floatValue]) {
            self.currentValue = i;
        }
    }
    self.currentValueChange = 8;
    [self displayPicker];
}

- (IBAction)selectValue:(id)sender {
    
    NSInteger rowSelected = [self.pcValues selectedRowInComponent:0];
    NSString *text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
    float value = [self.currentRange[rowSelected] floatValue];
    
    switch (self.currentValueChange) {
        case 1:
            self.lbTempSince.text = text;
            self.tValNormalSince = value;
            break;
        case 2:
            self.lbTempUntil.text = text;
            self.tValNormalUntil = value;
            break;
        case 3:
            self.lbRespSince.text = text;
            self.rValNormalSince = value;
            break;
        case 4:
            self.lbRespUntil.text = text;
            self.rValNormalUntil = value;
            break;
        case 5:
            self.lbCardSince.text = text;
            self.cValNormalSince = value;
            break;
        case 6:
            self.lbCardUntil.text = text;
            self.cValNormalUntil = value;
            break;
        case 7:
            self.lbMovSince.text = text;
            self.mValNormalSince = value;
            break;
        case 8:
            self.lbMovUntil.text = text;
            self.mValNormalUntil = value;
            break;
            
        default:
            break;
    }
    
    self.pcValues.hidden = YES;
    self.viAccept.hidden = YES;
    
}

#pragma mark - Picker View datasource methods

- (void)displayPicker {
    NSLog(@"displayPicker");
    NSLog(@"%@", self.currentRange);
    NSLog(@"%i", self.currentValue);
    [self.pcValues reloadAllComponents];
    self.pcValues.hidden = NO;
    self.viAccept.hidden = NO;
    if (self.currentValue != -1) {
        [self.pcValues selectRow:self.currentValue inComponent:0 animated:YES];
    }
    self.currentValue = -1;
}


- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.currentRange count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@", self.currentRange[row]];
}

#pragma mark - Picker View delegate methods

- (BOOL)validateMinMax:(NSInteger)rowSelected withRow: (int)row withType: (int)type{
    return YES;
}

- (IBAction)save:(id)sender {
    
    RBLAppDelegate *appDelegate = [RBLAppDelegate sharedAppDelegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSManagedObject *failedBankInfo = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Parameters"
                                       inManagedObjectContext:context];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.tValNormalSince] forKey:@"tNormalSince"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.tValNormalUntil] forKey:@"tNormalUntil"];
    
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.rValNormalSince] forKey:@"rNormalSince"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.rValNormalUntil] forKey:@"rNormalUntil"];
    
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.cValNormalSince] forKey:@"cNormalSince"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.cValNormalUntil] forKey:@"cNormalUntil"];
    
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.mValNormalSince] forKey:@"mNormalSince"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.mValNormalUntil] forKey:@"mNormalUntil"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    else {
        NSLog(@"Register saved");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainViewController *vc = (MainViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:YES andCompletion:nil];
    }
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}


@end
