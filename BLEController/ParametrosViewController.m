//
//  ParametrosViewController.m
//  BLEController
//
//  Created by Avances on 29/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import "ParametrosViewController.h"
#import "ParametroTableViewCell.h"
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

@interface ParametrosViewController ()

@property (nonatomic,strong) NSMutableArray *RANGE_TEMPERATURE;
@property (nonatomic,strong) NSMutableArray *RANGE_RESPIRATION;
@property (nonatomic,strong) NSMutableArray *RANGE_CARDIO;
@property (nonatomic,strong) NSMutableArray *RANGE_MOVEMENT;
@property (nonatomic,strong) NSMutableArray *currentRange;
@property (nonatomic,strong) NSIndexPath *ipClickedNow;
@property int currentValueChanged;

@property float tValNormalSince;
@property float tValNormalUntil;
@property float tValOutSince;
@property float tValOutUntil;

@property float rValNormalSince;
@property float rValNormalUntil;
@property float rValOutSince;
@property float rValOutUntil;

@property float cValNormalSince;
@property float cValNormalUntil;
@property float cValOutSince;
@property float cValOutUntil;

@property float mValNormalSince;
@property float mValNormalUntil;
@property float mValOutSince;
@property float mValOutUntil;


@end

@implementation ParametrosViewController

@synthesize RANGE_TEMPERATURE;
@synthesize RANGE_RESPIRATION;
@synthesize RANGE_CARDIO;
@synthesize RANGE_MOVEMENT;
@synthesize ipClickedNow;
@synthesize currentValueChanged;
@synthesize ble;
@synthesize protocol;

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
    NSLog(@"RANGE_TEMPERATURE: %i, %@", [RANGE_TEMPERATURE count], RANGE_TEMPERATURE);
    NSLog(@"RANGE_RESPIRATION: %i, %@", [RANGE_RESPIRATION count], RANGE_RESPIRATION);
    NSLog(@"RANGE_CARDIO: %i, %@", [RANGE_CARDIO count], RANGE_CARDIO);
    NSLog(@"RANGE_MOVEMENT: %i, %@", [RANGE_MOVEMENT count], RANGE_MOVEMENT);
    
    
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
            self.tValOutSince = [(NSNumber *)[info valueForKey:@"tOutSince"] floatValue];
            self.tValOutUntil = [(NSNumber *)[info valueForKey:@"tOutUntil"] floatValue];
            
            self.rValNormalSince = [(NSNumber *)[info valueForKey:@"rNormalSince"] floatValue];
            self.rValNormalUntil = [(NSNumber *)[info valueForKey:@"rNormalUntil"] floatValue];
            self.rValOutSince = [(NSNumber *)[info valueForKey:@"rOutSince"] floatValue];
            self.rValOutUntil = [(NSNumber *)[info valueForKey:@"rOutUntil"] floatValue];
            
            self.cValNormalSince = [(NSNumber *)[info valueForKey:@"cNormalSince"] floatValue];
            self.cValNormalUntil = [(NSNumber *)[info valueForKey:@"cNormalUntil"] floatValue];
            self.cValOutSince = [(NSNumber *)[info valueForKey:@"cOutSince"] floatValue];
            self.cValOutUntil = [(NSNumber *)[info valueForKey:@"cOutUntil"] floatValue];
            
            self.mValNormalSince = [(NSNumber *)[info valueForKey:@"mNormalSince"] floatValue];
            self.mValNormalUntil = [(NSNumber *)[info valueForKey:@"mNormalUntil"] floatValue];
            self.mValOutSince = [(NSNumber *)[info valueForKey:@"mOutSince"] floatValue];
            self.mValOutUntil = [(NSNumber *)[info valueForKey:@"mOutUntil"] floatValue];
        }
    }
    else{
        
        self.tValNormalSince = [(NSNumber *)[VALUES_TEMPERATURE objectForKey:@"normal"][0] floatValue];
        self.tValNormalUntil = [(NSNumber *)[VALUES_TEMPERATURE objectForKey:@"normal"][1] floatValue];
        self.tValOutSince = [(NSNumber *)[VALUES_TEMPERATURE objectForKey:@"out"][0] floatValue];
        self.tValOutUntil = [(NSNumber *)[VALUES_TEMPERATURE objectForKey:@"out"][1] floatValue];
        
        self.rValNormalSince = [(NSNumber *)[VALUES_RESPIRATION objectForKey:@"normal"][0] floatValue];
        self.rValNormalUntil = [(NSNumber *)[VALUES_RESPIRATION objectForKey:@"normal"][1] floatValue];
        self.rValOutSince = [(NSNumber *)[VALUES_RESPIRATION objectForKey:@"out"][0] floatValue];
        self.rValOutUntil = [(NSNumber *)[VALUES_RESPIRATION objectForKey:@"out"][1] floatValue];
        
        self.cValNormalSince = [(NSNumber *)[VALUES_CARDIO objectForKey:@"normal"][0] floatValue];
        self.cValNormalUntil = [(NSNumber *)[VALUES_CARDIO objectForKey:@"normal"][1] floatValue];
        self.cValOutSince = [(NSNumber *)[VALUES_CARDIO objectForKey:@"out"][0] floatValue];
        self.cValOutUntil = [(NSNumber *)[VALUES_CARDIO objectForKey:@"out"][1] floatValue];
        
        self.mValNormalSince = [(NSNumber *)[VALUES_MOVEMENT objectForKey:@"normal"][0] floatValue];
        self.mValNormalUntil = [(NSNumber *)[VALUES_MOVEMENT objectForKey:@"normal"][1] floatValue];
        self.mValOutSince = [(NSNumber *)[VALUES_MOVEMENT objectForKey:@"out"][0] floatValue];
        self.mValOutUntil = [(NSNumber *)[VALUES_MOVEMENT objectForKey:@"out"][1] floatValue];
        
    }
    
    ble = [BLE sharedInstance];
    protocol = [RBLProtocol sharedInstance];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BLE implementation

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
#if defined(MV_DEBUG)
    NSLog(@"->DidReceiveData");
#endif
    [self processData:data length:length];
}


NSTimer *syncTimer;

-(void) syncTimeout:(NSTimer *)timer
{
    
}

-(void) processData:(uint8_t *) data length:(uint8_t) length
{
}

-(void) protocolDidReceiveProtocolVersion:(uint8_t)major Minor:(uint8_t)minor Bugfix:(uint8_t)bugfix
{
   
}

-(void) protocolDidReceiveTotalPinCount:(UInt8) count
{
    
}

-(void) protocolDidReceivePinCapability:(uint8_t)pin Value:(uint8_t)value
{
}

-(void) protocolDidReceivePinData:(uint8_t)pin Mode:(uint8_t)mode Value:(uint8_t)value
{
    
    
}

-(void) protocolDidReceivePinMode:(uint8_t)pin Mode:(uint8_t)mode
{
   
}

-(void) protocolDidReceiveCustomData:(UInt8 *)data length:(UInt8)length
{
}

#pragma mark - Table View Implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath compare:_selectedIndexPath] == NSOrderedSame) {
        return 200;
    }
    else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParametroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *info = [NSDictionary new];
    switch (indexPath.row) {
        case TEMPERATURE:
            info = @{@"title":@"Temperatura",
                     @"icon": @"signo-grupal-temp-on.png",
                     @"normalSince": [NSNumber numberWithFloat:self.tValNormalSince],
                     @"normalUntil": [NSNumber numberWithFloat:self.tValNormalUntil],
                     @"outSince": [NSNumber numberWithFloat:self.tValOutSince],
                     @"outUntil": [NSNumber numberWithFloat:self.tValOutUntil]
                     };
            break;
        case RESPIRATION:
            info = @{@"title":@"Respiración",
                     @"icon": @"signo-grupal-resp-on.png",
                     @"normalSince": [NSNumber numberWithFloat:self.rValNormalSince],
                     @"normalUntil": [NSNumber numberWithFloat:self.rValNormalUntil],
                     @"outSince": [NSNumber numberWithFloat:self.rValOutSince],
                     @"outUntil": [NSNumber numberWithFloat:self.rValOutUntil]
                     };
            break;
        case CARDIO:
            info = @{@"title":@"Cardio",
                     @"icon": @"signo-grupal-card-on.png",
                     @"normalSince": [NSNumber numberWithFloat:self.cValNormalSince],
                     @"normalUntil": [NSNumber numberWithFloat:self.cValNormalUntil],
                     @"outSince": [NSNumber numberWithFloat:self.cValOutSince],
                     @"outUntil": [NSNumber numberWithFloat:self.cValOutUntil]
                     };
            break;
        case MOVEMENT:
            info = @{@"title":@"Movimiento",
                     @"icon": @"signo-grupal-mov-on.png",
                     @"normalSince": [NSNumber numberWithFloat:self.mValNormalSince],
                     @"normalUntil": [NSNumber numberWithFloat:self.mValNormalUntil],
                     @"outSince": [NSNumber numberWithFloat:self.mValOutSince],
                     @"outUntil": [NSNumber numberWithFloat:self.mValOutUntil]
                     };
            break;
        default:
            break;
    }
    cell.lbTitle.text = [info objectForKey:@"title"];
    cell.ivIcon.image = [UIImage imageNamed:[info objectForKey:@"icon"]];
    cell.lbNormalSince.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"normalSince"]];
    cell.lbNormalUntil.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"normalUntil"]];
    cell.lbOutSince.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"outSince"]];
    cell.lbOutUntil.text = [NSString stringWithFormat:@"%@", [info objectForKey:@"outUntil"]];
    cell.viShow.tag = indexPath.row;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCell:)];
    [cell.viShow addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *gestureTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPicker:)];
    UITapGestureRecognizer *gestureTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPicker:)];
    UITapGestureRecognizer *gestureTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPicker:)];
    UITapGestureRecognizer *gestureTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPicker:)];
    cell.viNormalSince.tag = [[NSString stringWithFormat:@"%d%@",indexPath.row, @1] intValue];
    [cell.viNormalSince addGestureRecognizer:gestureTap1];

    cell.viNormalUntil.tag = [[NSString stringWithFormat:@"%d%@",indexPath.row, @2] intValue];
    [cell.viNormalUntil addGestureRecognizer:gestureTap2];
    
    cell.viOutSince.tag = [[NSString stringWithFormat:@"%d%@",indexPath.row, @3] intValue];
    [cell.viOutSince addGestureRecognizer:gestureTap3];
    
    cell.viOutUntil.tag = [[NSString stringWithFormat:@"%d%@",indexPath.row, @4] intValue];
    [cell.viOutUntil addGestureRecognizer:gestureTap4];
    
    return cell;
}

- (IBAction)openPicker:(UITapGestureRecognizer *)sender{
    UIView *v = sender.view;
    int valueIndex = (int)v.tag / 10;
    ipClickedNow = [NSIndexPath indexPathForItem:valueIndex inSection:0];
    int currentValue = 0;
    currentValueChanged = v.tag % 10;
    float val;
    
    switch (valueIndex) {
        case 0:
            self.currentRange = RANGE_TEMPERATURE;
            val = (currentValueChanged == 1) ? self.tValNormalSince : (currentValueChanged == 2) ? self.tValNormalUntil : (currentValueChanged == 3) ? self.tValOutSince : self.tValOutUntil;
            break;
        case 1:
            self.currentRange = RANGE_RESPIRATION;
            val = (currentValueChanged == 1) ? self.rValNormalSince : (currentValueChanged == 2) ? self.rValNormalUntil : (currentValueChanged == 3) ? self.rValOutSince : self.rValOutUntil;
            break;
        case 2:
            self.currentRange = RANGE_CARDIO;
            val = (currentValueChanged == 1) ? self.cValNormalSince : (currentValueChanged == 2) ? self.cValNormalUntil : (currentValueChanged == 3) ? self.cValOutSince : self.cValOutUntil;
            break;
        case 3:
            self.currentRange = RANGE_MOVEMENT;
            val = (currentValueChanged == 1) ? self.mValNormalSince : (currentValueChanged == 2) ? self.mValNormalUntil : (currentValueChanged == 3) ? self.mValOutSince : self.mValOutUntil;
            break;
            
        default:
            break;
    }
    if (valueIndex == 0){
        for (int i=0; i < [self.currentRange count]; i++) {
            if ([(NSNumber *)self.currentRange[i] floatValue] == val) {
                currentValue = i;
                break;
            }
        }
    }
    else{
        int valInt = ceilf(val);
        for (int i=0; i < [self.currentRange count]; i++) {
            if ([(NSNumber *)self.currentRange[i] intValue] == valInt) {
                currentValue = i;
                break;
            }
        }
    }
    
    [self.pcValues reloadAllComponents];
    self.pcValues.hidden = NO;
    self.viAccept.hidden = NO;
    if (currentValue != 0) {
        [self.pcValues selectRow:currentValue inComponent:0 animated:YES];
    }
}

- (IBAction)toggleCell:(UITapGestureRecognizer *)sender{
    UIView *v = sender.view;
    NSIndexPath *clickedNow = [NSIndexPath indexPathForItem:v.tag inSection:0];
    NSIndexPath *ipOne =[NSIndexPath indexPathForItem:0 inSection:0],
    *ipTwo = [NSIndexPath indexPathForItem:1 inSection:0],
    *ipThree = [NSIndexPath indexPathForItem:2 inSection:0],
    *ipFour = [NSIndexPath indexPathForItem:3 inSection:0];
    ParametroTableViewCell *cellSelected = (ParametroTableViewCell *)[self.tableView cellForRowAtIndexPath:clickedNow];
    ParametroTableViewCell *cellOne = (ParametroTableViewCell *)[self.tableView cellForRowAtIndexPath:ipOne],
    *cellTwo = (ParametroTableViewCell *)[self.tableView cellForRowAtIndexPath:ipTwo],
    *cellThree = (ParametroTableViewCell *)[self.tableView cellForRowAtIndexPath:ipThree],
    *cellFour = (ParametroTableViewCell *)[self.tableView cellForRowAtIndexPath:ipFour];
    [self.tableView deselectRowAtIndexPath:clickedNow animated:NO];
    bool alreayopen= NO;
    UIImage *abrir =[UIImage imageNamed:@"men-arrow-off.png"];
    UIImage *cerrar =[UIImage imageNamed:@"men-arrow-on.png"];
    
    if ([clickedNow isEqual:_selectedIndexPath]) {
        alreayopen = YES;
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFromTop;
        animation.duration = 0.4;
        _selectedIndexPath = nil;
        [UIView animateWithDuration:2.0 animations:^{
            cellOne.ivShow.image = abrir;
            cellOne.viContainer.hidden = YES;
            cellTwo.ivShow.image = abrir;
            cellTwo.viContainer.hidden = YES;
            cellThree.ivShow.image = abrir;
            cellThree.viContainer.hidden = YES;
            cellFour.ivShow.image = abrir;
            cellFour.viContainer.hidden = YES;
        } completion:^(BOOL finished) {
            cellSelected.ivShow.image = abrir;
            cellSelected.viContainer.hidden = YES;
        }];
        
    }
    else {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFromBottom;
        animation.duration = 0.0;
        
        _selectedIndexPath = clickedNow;
        [UIView animateWithDuration:2.0 animations:^{
            cellOne.ivShow.image = abrir;
            cellOne.viContainer.hidden = YES;
            cellTwo.ivShow.image = abrir;
            cellTwo.viContainer.hidden = YES;
            cellThree.ivShow.image = abrir;
            cellThree.viContainer.hidden = YES;
            cellFour.ivShow.image = abrir;
            cellFour.viContainer.hidden = YES;
        } completion:^(BOOL finished) {
            cellSelected.ivShow.image = cerrar;
            cellSelected.viContainer.hidden = NO;
        }];
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}

#pragma mark - Picker View datasource methods

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

- (IBAction)selectValue:(id)sender {
    
    ParametroTableViewCell *cell = (ParametroTableViewCell *)[self.tableView cellForRowAtIndexPath:ipClickedNow];
    NSInteger rowSelected = [self.pcValues selectedRowInComponent:0];
    
    if ([self validateMinMax:rowSelected withRow:ipClickedNow.row withType:currentValueChanged]) {
        
        switch (ipClickedNow.row) {
            case 0:
                switch (currentValueChanged) {
                    case 1:
                        cell.lbNormalSince.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.tValNormalSince = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    case 2:
                        cell.lbNormalUntil.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.tValNormalUntil = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    case 3:
                        cell.lbOutSince.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.tValOutSince = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    case 4:
                        cell.lbOutUntil.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.tValOutUntil = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    default:
                        break;
                }
                break;
                
            case 1:
                switch (currentValueChanged) {
                    case 1:
                        cell.lbNormalSince.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.rValNormalSince = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    case 2:
                        cell.lbNormalUntil.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.rValNormalUntil = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    case 3:
                        cell.lbOutSince.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.rValOutSince = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    case 4:
                        cell.lbOutUntil.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.rValOutUntil = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    default:
                        break;
                }
                break;
                
            case 2:
                switch (currentValueChanged) {
                    case 1:
                        cell.lbNormalSince.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.cValNormalSince = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    case 2:
                        cell.lbNormalUntil.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.cValNormalUntil = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    case 3:
                        cell.lbOutSince.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.cValOutSince = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    case 4:
                        cell.lbOutUntil.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.cValOutUntil = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    default:
                        break;
                }
                break;
                
            case 3:
                switch (currentValueChanged) {
                    case 1:
                        cell.lbNormalSince.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.mValNormalSince = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    case 2:
                        cell.lbNormalUntil.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.mValNormalUntil = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    case 3:
                        cell.lbOutSince.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.mValOutSince = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    case 4:
                        cell.lbOutUntil.text = [NSString stringWithFormat:@"%@", self.currentRange[rowSelected]];
                        self.mValOutUntil = [(NSNumber *)self.currentRange[rowSelected] floatValue];
                        break;
                    default:
                        break;
                }
                break;
                
            default:
                break;
        }
        
        self.pcValues.hidden = YES;
        self.viAccept.hidden = YES;
        
    }
}

- (IBAction)save:(id)sender {
    
    RBLAppDelegate *appDelegate = [RBLAppDelegate sharedAppDelegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSManagedObject *failedBankInfo = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Parameters"
                                       inManagedObjectContext:context];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.tValNormalSince] forKey:@"tNormalSince"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.tValNormalUntil] forKey:@"tNormalUntil"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.tValOutSince] forKey:@"tOutSince"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.tValOutUntil] forKey:@"tOutUntil"];
    
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.rValNormalSince] forKey:@"rNormalSince"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.rValNormalUntil] forKey:@"rNormalUntil"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.rValOutSince] forKey:@"rOutSince"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.rValOutUntil] forKey:@"rOutUntil"];
    
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.cValNormalSince] forKey:@"cNormalSince"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.cValNormalUntil] forKey:@"cNormalUntil"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.cValOutSince] forKey:@"cOutSince"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.cValOutUntil] forKey:@"cOutUntil"];
    
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.mValNormalSince] forKey:@"mNormalSince"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.mValNormalUntil] forKey:@"mNormalUntil"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.mValOutSince] forKey:@"mOutSince"];
    [failedBankInfo setValue:[NSNumber numberWithFloat:self.mValOutUntil] forKey:@"mOutUntil"];
    
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
