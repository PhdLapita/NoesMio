//
//  SignosVitalesViewController.m
//  BLEController
//
//  Created by Avances on 28/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import "SignosVitalesViewController.h"
#import "Utils.h"
#import "TemporalViewController.h"
#import "SignoVitalViewController.h"
#import "RBLAppDelegate.h"

#import "ListadoVinculacionViewController.h"

NSString * const  UUIDPrefKey4 = @"UUIDPrefKey";

uint8_t total_pin_count  = 0;
uint8_t pin_mode[128]    = {0};
uint8_t pin_cap[128]     = {0};
uint8_t pin_digital[128] = {0};
uint16_t pin_analog[128]  = {0};
uint8_t pin_pwm[128]     = {0};
uint8_t pin_servo[128]   = {0};

uint8_t init_done = 0;

SignosVitalesViewController *cv;

@interface SignosVitalesViewController () 

@property(nonatomic,strong)NSTimer *timerIndicator;
@property(nonatomic,strong)NSArray *valuesCardio;
@property(nonatomic,strong)NSArray *valuesMov;
@property(nonatomic,strong)NSArray *valuesResp;
@property(nonatomic,strong)NSArray *valuesTemp;

@property(nonatomic,strong)NSArray *rankCardio;
@property(nonatomic,strong)NSArray *rankMov;
@property(nonatomic,strong)NSArray *rankResp;
@property(nonatomic,strong)NSArray *rankTemp;

@end

@implementation SignosVitalesViewController

@synthesize timerIndicator;
@synthesize rankCardio;
@synthesize rankMov;
@synthesize rankResp;
@synthesize rankTemp;
@synthesize protocol;
@synthesize ble;
@synthesize switchActivated;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.valuesCardio = @[@60, @62, @63, @65, @66, @70, @73, @74, @100, @100, @100];
    self.valuesMov = @[@50, @51, @63, @55, @57, @62, @65, @67, @70, @70, @70];
    self.valuesResp = @[@12, @13, @13, @14, @14, @15, @16, @16, @16, @16, @16];
    self.valuesTemp = @[@36.5, @36.6, @36.7, @36.8, @36.9, @37, @37.1, @37.2, @38, @38, @38];
  
    rankCardio = [NSArray new];
    rankMov = [NSArray new];
    rankResp = [NSArray new];
    rankTemp = [NSArray new];
    
    NSArray *imagesCardio = @[@"signo-grupal-card-on.png", @"signo-grupal-card.png"];
    NSArray *imagesMov = @[@"signo-grupal-mov-on.png", @"signo-grupal-mov.png"];
    NSArray *imagesResp = @[@"signo-grupal-resp-on.png", @"signo-grupal-resp.png"];
    NSArray *imagesTemp = @[@"signo-grupal-temp-on.png", @"signo-grupal-temp.png"];
    NSMutableArray *imgC = [NSMutableArray new], *imgM = [NSMutableArray new], *imgR = [NSMutableArray new], *imgT = [NSMutableArray new];
    NSLog(@"%d", imagesCardio.count);
    for (int i = 0; i < 2; i++) {
        [imgC addObject:[UIImage imageNamed:[imagesCardio objectAtIndex:i]]];
        [imgM addObject:[UIImage imageNamed:[imagesMov objectAtIndex:i]]];
        [imgR addObject:[UIImage imageNamed:[imagesResp objectAtIndex:i]]];
        [imgT addObject:[UIImage imageNamed:[imagesTemp objectAtIndex:i]]];
    }
    
    self.ivCardio.animationImages = imgC;
    self.ivCardio.animationDuration = 1.0;
    self.ivMovement.animationImages = imgM;
    self.ivMovement.animationDuration = 1.0;
    self.ivRespiration.animationImages = imgR;
    self.ivRespiration.animationDuration = 1.0;
    self.ivTemperature.animationImages = imgT;
    self.ivTemperature.animationDuration = 1.0;
    [self.ivCardio startAnimating];
    [self.ivMovement startAnimating];
    [self.ivRespiration startAnimating];
    [self.ivTemperature startAnimating];
    self.lbDate.text = [Utils getFullTextDate];
    
    
    ble = [BLE sharedInstance];
    ble.delegate = self;
    
    //protocol = [[RBLProtocol alloc] init];
    protocol = [RBLProtocol sharedInstance];
    protocol.delegate = self;
    protocol.ble = ble;
    switchActivated = NO;
    
    timerIndicator = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changeValueIndicator) userInfo:nil repeats:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"ControlView: viewDidAppear");
    
    [self blockScreen];
    
    syncTimer = [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(syncTimeout:) userInfo:nil repeats:NO];
    
    [protocol queryProtocolVersion];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"ControlView: viewWillDisappear");
    [syncTimer invalidate];
    [timerIndicator invalidate];
    total_pin_count = 0;
    init_done = 0;
    [self stopVibrationAndFinish];
    //ble.delegate = nil;
    //protocol.delegate = nil;
    
}

#pragma mark - BLE implementation

NSTimer *syncTimer;

-(void) syncTimeout:(NSTimer *)timer
{
    NSLog(@"Timeout: no response");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"No response from the BLE Controller sketch."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    // disconnect it
    [ble.CM cancelPeripheralConnection:ble.activePeripheral];
}



-(void) processData:(uint8_t *) data length:(uint8_t) length
{
#if defined(CV_DEBUG)
    NSLog(@"ControlView: processData");
    NSLog(@"Length: %d", length);
#endif
    
    [protocol parseData:data length:length];
}

-(void) protocolDidReceiveProtocolVersion:(uint8_t)major Minor:(uint8_t)minor Bugfix:(uint8_t)bugfix
{
    NSLog(@"protocolDidReceiveProtocolVersion: %d.%d.%d", major, minor, bugfix);
    
    // get response, so stop timer
    [syncTimer invalidate];
    
    uint8_t buf[] = {'B', 'L', 'E'};
    [protocol sendCustomData:buf Length:3];
    
    [protocol queryTotalPinCount];
}

-(void) protocolDidReceiveTotalPinCount:(UInt8) count
{
    NSLog(@"protocolDidReceiveTotalPinCount: %d", count);
    
    total_pin_count = count;
    [protocol queryPinAll];
}

-(void) protocolDidReceivePinCapability:(uint8_t)pin Value:(uint8_t)value
{
    NSLog(@"protocolDidReceivePinCapability");
    NSLog(@" Pin %d Capability: 0x%02X", pin, value);
    
    if (value == 0)
        NSLog(@" - Nothing");
    else
    {
        if (value & PIN_CAPABILITY_DIGITAL)
            NSLog(@" - DIGITAL (I/O)");
        if (value & PIN_CAPABILITY_ANALOG)
            NSLog(@" - ANALOG");
        if (value & PIN_CAPABILITY_PWM)
            NSLog(@" - PWM");
        if (value & PIN_CAPABILITY_SERVO)
            NSLog(@" - SERVO");
    }
    
    pin_cap[pin] = value;
    
    if (pin == 10) {
        [protocol setPinMode:10 Mode:OUTPUT];
    }
    else if (pin == 11) {
        [protocol setPinMode:11 Mode:OUTPUT];
    }
    
    if (pin >= 23){
        [self unblockScreen];
        //self.aiLoad.hidden = YES;
    }
}

-(void) protocolDidReceivePinData:(uint8_t)pin Mode:(uint8_t)mode Value:(uint8_t)value
{
    //    NSLog(@"protocolDidReceiveDigitalData");
    //    NSLog(@" Pin: %d, mode: %d, value: %d", pin, mode, value);
    
    uint8_t _mode = mode & 0x0F;
    
    pin_mode[pin] = _mode;
    if ((_mode == INPUT) || (_mode == OUTPUT))
        pin_digital[pin] = value;
    else if (_mode == ANALOG)
        pin_analog[pin] = ((mode >> 4) << 8) + value;
    else if (_mode == PWM)
        pin_pwm[pin] = value;
    else if (_mode == SERVO)
        pin_servo[pin] = value;
    
}

-(void) protocolDidReceivePinMode:(uint8_t)pin Mode:(uint8_t)mode
{
    NSLog(@"protocolDidReceivePinMode");
    
    if (mode == INPUT)
        NSLog(@" Pin %d Mode: INPUT", pin);
    else if (mode == OUTPUT)
        NSLog(@" Pin %d Mode: OUTPUT", pin);
    else if (mode == PWM)
        NSLog(@" Pin %d Mode: PWM", pin);
    else if (mode == SERVO)
        NSLog(@" Pin %d Mode: SERVO", pin);
    
    pin_mode[pin] = mode;
}

-(void) protocolDidReceiveCustomData:(UInt8 *)data length:(UInt8)length
{
    // Handle your customer data here.
    for (int i = 0; i< length; i++)
        printf("0x%2X ", data[i]);
    printf("\n");
}


-(void) bleDidConnect
{
    NSLog(@"->DidConnect");
    
    self.lastUUID = [self getUUIDString:ble.activePeripheral.UUID];
    [[NSUserDefaults standardUserDefaults] setObject:self.lastUUID forKey:UUIDPrefKey4];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.lastUUID = [[NSUserDefaults standardUserDefaults] objectForKey:UUIDPrefKey4];
    if ([self.lastUUID isEqualToString:@""]) {
        
    } else {
        
    }
    
    /*
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    SignosVitalesViewController *vc = (SignosVitalesViewController*)[mainStoryboard
                                                                     instantiateViewControllerWithIdentifier: @"SignosVitalesViewController"];
    vc.ble = ble;
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withCompletion:nil];
     */
    
}

- (void)bleDidDisconnect
{
    NSLog(@"->DidDisconnect");
    
    //[self.navigationController popToRootViewControllerAnimated:true];
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
#if defined(MV_DEBUG)
    NSLog(@"->DidReceiveData");
#endif
    
    if (cv != nil)
    {
        [cv processData:data length:length];
    }
}

-(void) bleDidUpdateRSSI:(NSNumber *) rssi
{
}

-(NSString *)getUUIDString:(CFUUIDRef)ref {
    NSString *str = [NSString stringWithFormat:@"%@", ref];
    return [[NSString stringWithFormat:@"%@", str] substringWithRange:NSMakeRange(str.length - 36, 36)];
}

#pragma mark - Page implementation

- (void)changeValueIndicator{
    self.lbCardio.text = [Utils pickRandomValue:self.valuesCardio];
    self.lbRespiration.text = [Utils pickRandomValue:self.valuesResp];
    self.lbTemperature.text = [Utils pickRandomValue:self.valuesTemp];
    self.lbMovement.text = [Utils pickRandomValue:self.valuesMov];
    
    [self validateVibration];
}

- (void)validateVibration{
    NSLog(@"validateVibration : %i", rankMov.count);
    BOOL isVibrating = NO;
    if (rankMov.count == 0) {
        RBLAppDelegate *appDelegate = [RBLAppDelegate sharedAppDelegate];
        NSManagedObjectContext *context = appDelegate.managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Parameters" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *info in fetchedObjects) {
            rankMov = @[[info valueForKey:@"mNormalSince"], [info valueForKey:@"mNormalUntil"]];
            rankResp = @[[info valueForKey:@"rNormalSince"], [info valueForKey:@"rNormalUntil"]];
            rankTemp = @[[info valueForKey:@"tNormalSince"], [info valueForKey:@"tNormalUntil"]];
            rankCardio = @[[info valueForKey:@"cNormalSince"], [info valueForKey:@"cNormalUntil"]];
        }
        
    }
    
    if (rankMov.count != 0) {
        if ([self.lbMovement.text floatValue] < [rankMov[0] floatValue] ||
            [self.lbMovement.text floatValue] > [rankMov[1] floatValue]) {
            isVibrating = YES;
        }
        
        if ([self.lbRespiration.text floatValue] < [rankResp[0] floatValue] ||
            [self.lbRespiration.text floatValue] > [rankResp[1] floatValue]) {
            isVibrating = YES;
        }
        
        if ([self.lbTemperature.text floatValue] < [rankTemp[0] floatValue] ||
            [self.lbTemperature.text floatValue] > [rankTemp[1] floatValue]) {
            isVibrating = YES;
        }
        
        if ([self.lbCardio.text floatValue] < [rankCardio[0] floatValue] ||
            [self.lbCardio.text floatValue] > [rankCardio[1] floatValue]) {
            isVibrating = YES;
        }
        
        NSLog(@"isVibrating %@", isVibrating ? @"YES" : @"NO");
        
        if (isVibrating) {
            [self vibrateDevice];
        }
        else {
            [self stopVibration];
        }
    }
    
}

- (void)vibrateDevice{

    [protocol digitalWrite:10 Value:HIGH];
    [protocol digitalWrite:11 Value:HIGH];
    pin_digital[10] = HIGH;
    pin_digital[11] = HIGH;
    NSLog(@"VIBRATING");
    NSLog(@"====================================================");
}
- (void)stopVibration{
    
    [protocol digitalWrite:10 Value:LOW];
    [protocol digitalWrite:11 Value:LOW];
    pin_digital[10] = LOW;
    pin_digital[11] = LOW;
    NSLog(@"NOT VIBRATING");
    NSLog(@"====================================================");
}

- (void)stopVibrationAndFinish{
    NSLog(@"%@", protocol);
    [protocol digitalWrite:10 Value:LOW];
    [protocol digitalWrite:11 Value:LOW];
    pin_digital[10] = LOW;
    pin_digital[11] = LOW;
    NSLog(@"NOT VIBRATING FINISH VIEW");
    NSLog(@"====================================================");
    ble.delegate = nil;
    protocol.delegate = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openDetail:(int)value{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TemporalViewController *vcAux = [mainStoryboard instantiateViewControllerWithIdentifier:@"TemporalViewController"];
    SignoVitalViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SignoVitalViewController"];
    vc.indicatorType = value;
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vcAux withSlideOutAnimation:NO andCompletion:^{
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:NO andCompletion:nil];
    }];
}

- (IBAction)openTemperature:(id)sender {
    [self openDetail:1];
}

- (IBAction)openRespiration:(id)sender {
    [self openDetail:2];
}

- (IBAction)openCardio:(id)sender {
    [self openDetail:3];
}

- (IBAction)openMovement:(id)sender {
    [self openDetail:4];
}

- (void)blockScreen{
    self.viLoading.hidden = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.navigationController.view.userInteractionEnabled = NO;
}

- (void)unblockScreen{
    self.viLoading.hidden = YES;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    self.navigationController.view.userInteractionEnabled = YES;
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    ble.activePeripheral = nil;
    
    NSLog(@"alertviewdelegate");
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ListadoVinculacionViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ListadoVinculacionViewController"];
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:NO andCompletion:nil];
    
}

@end
