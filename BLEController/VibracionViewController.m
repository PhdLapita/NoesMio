//
//  VibracionViewController.m
//  BLEController
//
//  Created by Avances on 30/10/15.
//  Copyright (c) 2015 RedBearLab. All rights reserved.
//

#import "VibracionViewController.h"
#import "ListadoVinculacionViewController.h"

NSString* const ACTIVADO = @"Activado";
NSString* const DESACTIVADO = @"Desactivado";

static UIColor *green;
static UIColor *brown;
static UIImage *active;
static UIImage *inactive;

uint8_t total_pin_count2  = 0;
uint8_t pin_mode2[128]    = {0};
uint8_t pin_cap2[128]     = {0};
uint8_t pin_digital2[128] = {0};
uint16_t pin_analog2[128]  = {0};
uint8_t pin_pwm2[128]     = {0};
uint8_t pin_servo2[128]   = {0};

uint8_t init_done2 = 0;

@interface VibracionViewController ()

@property BOOL status;

@end

@implementation VibracionViewController

@synthesize status;
@synthesize ble;
@synthesize protocol;
@synthesize switchActivated;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"vibracionViewController viewDidLoad");
    green = [UIColor colorWithRed:36/255.f green:162/255.f blue:43/255.f alpha:1.0];
    brown = [UIColor colorWithRed:167/255.f green:160/255.f blue:151/255.f alpha:1.0];
    status = NO;
    active = [UIImage imageNamed:@"vib-prenda-on.png"];
    inactive = [UIImage imageNamed:@"vib-prenda-off.png"];
    // Do any additional setup after loading the view.
    
    ble = [BLE sharedInstance];
    //[ble controlSetup];
    ble.delegate = self;
    
    //protocol = [[RBLProtocol alloc] init];
    protocol = [RBLProtocol sharedInstance];
    protocol.delegate = self;
    protocol.ble = ble;
    switchActivated = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"vibracionViewController: viewDidAppear");
    
    //syncTimer = [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(syncTimeout:) userInfo:nil repeats:NO];
    
    //[protocol queryProtocolVersion];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"vibracionViewController: viewDidDisappear");
    total_pin_count2 = 0;
    init_done2 = 0;
    status = YES;
    [self activate:nil];
    ble.delegate = nil;
    protocol.delegate = nil;
}

#pragma mark - BLE Implementation

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
    NSLog(@"Timeout: no response");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"No response from the BLE Controller sketch."
                                                   delegate:nil
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
    
    total_pin_count2 = count;
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
    
    pin_cap2[pin] = value;
    
    if (pin == 10) {
        [protocol setPinMode:10 Mode:OUTPUT];
    }
    else if (pin == 11) {
        [protocol setPinMode:11 Mode:OUTPUT];
    }
    
    if (pin >= 23){
        //self.aiLoad.hidden = YES;
    }
}

-(void) protocolDidReceivePinData:(uint8_t)pin Mode:(uint8_t)mode Value:(uint8_t)value
{
    //    NSLog(@"protocolDidReceiveDigitalData");
    //    NSLog(@" Pin: %d, mode: %d, value: %d", pin, mode, value);
    
    uint8_t _mode = mode & 0x0F;
    
    pin_mode2[pin] = _mode;
    if ((_mode == INPUT) || (_mode == OUTPUT))
        pin_digital2[pin] = value;
    else if (_mode == ANALOG)
        pin_analog2[pin] = ((mode >> 4) << 8) + value;
    else if (_mode == PWM)
        pin_pwm2[pin] = value;
    else if (_mode == SERVO)
        pin_servo2[pin] = value;
    
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
    
    pin_mode2[pin] = mode;
}

-(void) protocolDidReceiveCustomData:(UInt8 *)data length:(UInt8)length
{
    // Handle your customer data here.
    for (int i = 0; i< length; i++)
        printf("0x%2X ", data[i]);
    printf("\n");
}

- (void)changeValueIndicator{
}

- (IBAction)activate:(id)sender {
    status = !status;
    if (status) {
        [self.view setBackgroundColor:green];
        self.lbStatus.textColor = [UIColor whiteColor];
        self.lbStatus.text = ACTIVADO;
        self.ivCloth.image = active;
        [protocol digitalWrite:10 Value:HIGH];
        [protocol digitalWrite:11 Value:HIGH];
        pin_digital2[10] = HIGH;
        pin_digital2[11] = HIGH;
    }
    else {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.lbStatus.textColor = brown;
        self.lbStatus.text = DESACTIVADO;
        self.ivCloth.image = inactive;
        [protocol digitalWrite:10 Value:LOW];
        [protocol digitalWrite:11 Value:LOW];
        pin_digital2[10] = LOW;
        pin_digital2[11] = LOW;

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    ble.activePeripheral = nil;
    
    NSLog(@"alertviewdelegate");
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ListadoVinculacionViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ListadoVinculacionViewController"];
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:NO andCompletion:nil];
    
}

@end
